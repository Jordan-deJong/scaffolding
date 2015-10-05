require "scaffolding/version"

module Scaffolding
  if defined?(Rails)
    require 'scaffolding/railtie'
    # Dir.mkdir(source.join(Rails.root, 'tmp/scaffolding'))
  end

  def self.generate(source, auto, migrate, import)
    @source = source
    @migrate = migrate
    @import = import
    results = Scaffolding::Parser::Csv.process(@source, auto)
    return if Scaffolding.errors(results)
    Rails::Generators::Base.new.generate "scaffold", results
    Scaffolding.import_data if Scaffolding.migrate_database
  end

  def self.errors(results)
    if results.kind_of?(Array)
      results.each do |error|
        puts "\e[31m#{error}\e[0m"
      end
      true
    end
  end

  def self.migrate_database
    unless @migrate
      puts "\n\n\e[32mMigrate the database?(y/n)\e[0m\n"
      answer = STDIN.gets.chomp.downcase
    end
    if @migrate || answer == "y"
      Rake::Task["db:migrate"].invoke
    else
      false
    end
  end

  def self.import_data
    unless @import
      puts "\n\n\e[32mImport the data from #{@source}?(y/n)\e[0m\n"
      answer = STDIN.gets.chomp.downcase
    end
    if @import || answer == "y"
      Scaffolding::Parser::Importer::CsvData.process(@source, false).each do |k,v|
        puts "#{v} records #{k}"
      end
    end
  end

end

require 'scaffolding/parser/base'
require 'scaffolding/parser/csv'
require 'scaffolding/parser/importer/csvdata'
