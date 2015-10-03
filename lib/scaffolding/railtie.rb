require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie
    rake_tasks do
      # load "../scaffolding/lib/scaffolding/tasks/generators.rake"
      load "tasks/generators.rake"
    end
    generators do
      require "generators/scaffolding_generator.rb"
    end
  end
end
