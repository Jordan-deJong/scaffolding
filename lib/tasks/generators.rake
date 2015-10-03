namespace :g do
  desc 'generate a scaffold from a csv file'
  task :scaffold, [:file] do |t, args|
    require 'rails/generators'
    require 'scaffolding'

    system "clear" or system "cls"
    puts "\n***** Scaffolding Gem *****\n\n\n"

    if args[:file]
      file = args[:file]
    else
      puts "\e[32mEnter a relative file name to build the scaffold\e[0m\n"
      puts "You are currently here: #{Dir.pwd}\n\n"
      file = STDIN.gets.chomp
    end

    results = Scaffolding.generate(file)
    if results.kind_of?(Array)
      results.each do |error|
        puts "\e[31m#{error}\e[0m"
      end
      puts ""
      next
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
