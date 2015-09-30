require "bundler/gem_tasks"

task :gscaffold do |t|
  require 'scaffolding'

  system "clear" or system "cls"
  puts "\n***** Scaffolding Gem *****\n\n\n"
  puts "Enter a relative file name to build the scaffold\n".green
  puts "Example:"
  puts '../../../../desktop/ht.csv'
  puts 'C:\Users\jdejong\Desktop\Windows.csv'
  puts ""
  file = STDIN.gets.chomp

  Scaffolding.build(file)
end
