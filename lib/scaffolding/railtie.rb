require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie

    rake_tasks do
      load "tasks/generators.rake"
    end

  end
end
