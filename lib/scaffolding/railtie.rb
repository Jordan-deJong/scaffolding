require 'scaffolding'
require 'rails'

module Scaffolding
  class Generators < Rails::Railtie
    require 'pry'

    rake_tasks do
      binding.pry
      load 'tasks/generators.rake'
    end

  end
end
