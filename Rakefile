require "bundler/gem_tasks"

task :console do
  require 'irb'
  require 'irb/completion'
  require 'scaffolding'
  ARGV.clear
  IRB.start
end

task :b do |t|
  require 'scaffolding'

  system "clear" or system "cls"
  puts "\n***** Scaffolding Gem *****\n\n\n"
  puts "Enter a relative file name to build the scaffold".green
  file = STDIN.gets.chomp

  Scaffolding.build(file)
  # 'C:\Users\jdejong\Desktop\Windows.csv'
end
