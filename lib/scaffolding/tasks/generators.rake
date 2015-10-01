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
    file = STDIN.gets.chomp
    results = Scaffolding.build(file)

    if results.kind_of?(Array)
      results.each do |error|
        puts "\e[31m#{error}\e[0m"
      end
      puts ""
      next
    end

    puts "\n\n\n\e[32mWould you like to generate the scaffold now?(y/n)\e[0m\n"
    answer = STDIN.gets.chomp

    if answer == "y"
      exec results.to_s
    else
      puts "\nHeres the code:"
      puts results.to_s
      next
    end

    puts "\n\n\n\e[32mMigrate the database?(y/n)\e[0m\n"
    answer = STDIN.gets.chomp

    if answer == "y"
      exec "rake db:migrate"
    end

  end
end
