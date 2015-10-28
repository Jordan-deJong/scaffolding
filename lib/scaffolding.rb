require "scaffolding/version"

module Scaffolding
  require 'scaffolding/railtie' if defined?(Rails)
  require 'rails/generators'
  class Build
    require 'uri'

    def initialize(source, name, auto, migrate, import)
      @source, @name, @auto, @migrate, @import = source, name, auto, migrate, import
      @uri = uri?
      upload?
      @parser = parser
    end

    def uri?
      @source =~ URI::regexp
    end

    def upload?
      @source = @source.path if @source.class == ActionDispatch::Http::UploadedFile
    end

    def parser
      "Scaffolding::Parser::#{class_ref}".constantize.new(@source, @name, @auto, @uri)
    end

    def class_ref
      if File.extname(@source) == ".csv" && @uri == nil
        "Csv"
      else
        "Raw"
      end
    end

    def time(method)
      beginning_time = Time.now
      self.send(method)
      end_time = Time.now
      puts "#{@parser.source_name} processed in #{(end_time - beginning_time).round(2)} seconds\n\n"
    end

    def stack
      @results = @parser.results
      return if errors
      generate
      import_data if migrate_database
    end

    def generate
      Rails::Generators::Base.new.generate "scaffold", @results
    end

    def errors
      if @results.kind_of?(Array)
        @results.each do |error|
          puts "\e[31m#{error}\e[0m"
        end
        true
      end
    end

    def migrate_database
      unless @migrate
        puts "\n\n\e[32mMigrate the database?(y/n)\e[0m\n"
        answer = STDIN.gets.chomp.downcase
      end
      if @migrate || answer == "y"
        Rake::Task["db:migrate"].reenable
        Rake::Task["db:migrate"].invoke
      else
        false
      end
    end

    def import_data
      unless @import
        puts "\n\n\e[32mImport the data from #{@source}?(y/n)\e[0m\n"
        answer = STDIN.gets.chomp.downcase
      end
      if @import || answer == "y"
        @results = @parser.import_data
        return if errors
        puts "\e[32m#{@results[:saved]}\e[0m records saved"
        puts "\e[31m#{@results[:failed]}\e[0m records failed"
      end
    end

    def import_browser_data
      @parser.groom_data
      results = @parser.import_data
      return if errors
      {saved: results[:saved], failed: results[:failed]}
    end
  end

end

require 'scaffolding/parser/base'
require 'scaffolding/parser/raw'
require 'scaffolding/parser/csv'
