require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie
    railtie_name :builders

    rake_tasks do
      # load "../scaffolding/lib/scaffolding/tasks/generators.rake"
      load "tasks/generators.rake"
    end
  end
end
