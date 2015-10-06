require 'rails/generators'
require 'rake'
Rails.application.load_tasks
require 'scaffolding'

class ScaffoldingGenerator < Rails::Generators::Base
  desc "This generator generates a scaffold based on a CSV file and imports the data"
  argument :source, :type => :string, :default => ""
  class_option :auto, :type => :boolean, :default => false, :description => "Automatically choose data types"
  class_option :migrate, :type => :boolean, :default => false, :description => "Migrate the database"
  class_option :import, :type => :boolean, :default => false, :description => "Import data from source"

  def analyize_sources
    @auto = options[:auto]
    @migrate = options[:migrate]
    @import = options[:import]

    if source == "" || source.nil?
      Dir[Rails.root.join('tmp/scaffolding/*')].each do |source|
        Scaffolding.generate(source, @auto, @migrate, @import)
      end
    else
      Scaffolding.generate(source, @auto, @migrate, @import)
    end
  end

end
