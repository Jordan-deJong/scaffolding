require "scaffolding/version"

module Scaffolding
  require 'scaffolding/railtie' if defined?(Rails)
  class Build
    require 'uri'

    def initialize(source, name, auto, migrate, import)
      @source = source
      @name = name
      @auto = auto
      @migrate = migrate
      @import = import
      @uri = uri?
    end

    def uri?
      @source =~ URI::regexp
    end

    def stack
      @results = parser
      return if errors
      generate
      import_data if migrate_database
    end

    def parser(namespace="")
      "Scaffolding::Parser#{namespace + "::" + class_ref}".constantize.process(@source, @name, @auto, @uri)
    end

    def class_ref
      case File.extname(@source)
      when ".csv" && @uri.nil?
        "Csv"
      else
        "Raw"
      end
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
      parser("::Importer").each{ |k,v| puts "#{v} records #{k}" } if @import || answer == "y"
    end
  end

  def production_controller
    Rails::Generators::Base.new.generate "controller", "scaffolding"
  end
end

require 'scaffolding/parser/base'
require 'scaffolding/parser/raw'
require 'scaffolding/parser/csv'
require 'scaffolding/parser/importer/base'
