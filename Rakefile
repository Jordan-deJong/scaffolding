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
  puts "Enter a relative file name to build the scaffold"
  file = STDIN.gets.chomp
  Scaffolding.build('C:\Users\jdejong\Desktop\Windows.csv')
end
