namespace :g do
  desc 'generate a scaffold from file'
  task :scaffold do |t|
    require 'scaffolding'

    system "clear" or system "cls"
    puts "\n***** Scaffolding Gem *****\n\n\n"
    puts "\e[32mEnter a relative file name to build the scaffold\e[0m\n"
    puts "Example:"
    puts '../../../../desktop/mac.csv'
    puts 'C:\Users\username\Desktop\Windows.csv'
    puts ""
    @file = STDIN.gets.chomp

    results = Scaffolding.generate(@file)
    if results.kind_of?(Array)
      results.each do |error|
        puts "\e[31m#{error}\e[0m"
      end
      puts ""
      next
    end

    puts "\n\n\n\e[32mWould you like to generate the scaffold now?(y/n)\e[0m"

    if STDIN.gets.chomp == "y"
      puts "\n\n\e[32mMigrate the database?(y/n)\e[0m\n"

      if STDIN.gets.chomp == "y"
        puts "\n\n\e[32mImport the data from #{@file}?(y/n)\e[0m\n"
        import = STDIN.gets.chomp

        exec results.to_s + "; rake db:migrate"
        Scaffolding.import_data(@file) if import == "y"
      else
        exec results.to_s
      end

    else
      puts "\nHeres the code:"
      puts results.to_s
    end
  end
end
