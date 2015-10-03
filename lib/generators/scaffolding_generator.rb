require 'rails/generators'
require 'rake'
Rails.application.load_tasks
require 'scaffolding'

class ScaffoldingGenerator < Rails::Generators::Base
  argument :file, :type => :string, :default => ""

  def generate_scaffold
    results = Scaffolding.generate(file)

    if results.kind_of?(Array)
      results.each do |error|
        puts "\e[31m#{error}\e[0m"
      end
      return
    end

    Rails::Generators::Base.new.generate "scaffold", results

    puts "\n\n\e[32mMigrate the database?(y/n)\e[0m\n"
    if STDIN.gets.chomp == "y"
      Rake::Task["db:migrate"].invoke

      puts "\n\n\e[32mImport the data from #{file}?(y/n)\e[0m\n"
      if STDIN.gets.chomp == "y"
        Scaffolding.import_data(file).each do |k,v|
          puts "#{v} records #{k}"
        end
      end
    end
  end

end
