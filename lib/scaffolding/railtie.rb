require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie
    rake_tasks do
      # load "../scaffolding/lib/scaffolding/tasks/generators.rake"
      load "tasks/generators.rake"
    end
    generators do
      require "scaffolding/generators/scaffolding_generator"
    end
  end
end
