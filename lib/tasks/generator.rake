task :gscaffold do |t|
  require 'scaffolding'

  system "clear" or system "cls"
  puts "\n***** Scaffolding Gem *****\n\n\n"
  puts "\e[32mEnter a relative file name to build the scaffold\e[0m\n"
  puts "Example:"
  puts '../../../../desktop/ht.csv'
  puts 'C:\Users\jdejong\Desktop\Windows.csv'
  puts ""
  file = STDIN.gets.chomp

  Scaffolding.build(file)
end
