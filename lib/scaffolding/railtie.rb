require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie

    rake_tasks do
      load "../scaffolding/lib/scaffolding/tasks/generators.rake"
    end

  end
end
