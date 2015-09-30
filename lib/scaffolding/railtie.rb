module Scaffolding
  class Generators < Rails::Railtie
    rake_tasks do
      load "tasks/generator.rake"
    end
  end
end
