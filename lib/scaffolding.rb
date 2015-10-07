require "scaffolding/version"

module Scaffolding
  require 'scaffolding/railtie' if defined?(Rails)
  require 'uri'

  def self.generate(source, name, auto, migrate, import)
    @source = source
    @name = name
    @auto = auto
    @migrate = migrate
    @import = import
    @uri = Scaffolding.uri?

    results = Scaffolding.parser
    return if Scaffolding.errors(results)

    Rails::Generators::Base.new.generate "scaffold", results
    Scaffolding.import_data if Scaffolding.migrate_database
  end

  def self.uri?
    @source =~ URI::regexp
  end

  def self.parser(namespace="")
    "Scaffolding::Parser#{namespace + "::" + Scaffolding.class_ref}".constantize.process(@source, @name, @auto, @uri)
  end

  def self.class_ref
    case File.extname(@source)
    when ".csv" && @uri == false
      "Csv"
    else
      "Raw"
    end
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
      Rake::Task["db:migrate"].reenable
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
    Scaffolding.parser("::Importer").each{ |k,v| puts "#{v} records #{k}" } if @import || answer == "y"
  end

end

require 'scaffolding/parser/base'
require 'scaffolding/parser/raw'
require 'scaffolding/parser/csv'
require 'scaffolding/parser/importer/base'
