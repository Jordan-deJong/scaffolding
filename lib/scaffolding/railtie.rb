require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie
    rake_tasks do
      load "tasks/generators.rake"
    end    
    generators do
      require "generators/scaffolding_generator.rb"
    end
  end
end
