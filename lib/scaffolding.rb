require "scaffolding/version"

module Scaffolding
  if defined?(Rails)
    require 'scaffolding/railtie'
    Dir.mkdir(Rails.root.join('tmp/scaffolding/*'))
  end

  def self.generate(file)
    @file = file
    results = Scaffolding::Parser::Csv.process(@file)
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
    puts "\n\n\e[32mMigrate the database?(y/n)\e[0m\n"
    if STDIN.gets.chomp == "y"
      Rake::Task["db:migrate"].invoke
    else
      false
    end
  end

  def self.import_data
    puts "\n\n\e[32mImport the data from #{@file}?(y/n)\e[0m\n"
    if STDIN.gets.chomp == "y"
      Scaffolding::Parser::Importer::CsvData.process(@file).each do |k,v|
        puts "#{v} records #{k}"
      end
    end
  end

end

require 'scaffolding/parser/base'
require 'scaffolding/parser/csv'
require 'scaffolding/parser/importer/csvdata'
