require 'rake'
Rails.application.load_tasks
require 'scaffolding'

class ScaffoldingGenerator < Rails::Generators::Base
  desc "This generator generates a scaffold based on a CSV, Dat or Txt file and imports the data"
  argument :source, :type => :string, :default => ""
  argument :name, :type => :string, :default => ""
  class_option :auto, :type => :boolean, :default => false, :description => "Automatically choose data types"
  class_option :migrate, :type => :boolean, :default => false, :description => "Migrate the database"
  class_option :import, :type => :boolean, :default => false, :description => "Import data from source"

  def analyize_sources
    @auto = options[:auto]
    @migrate = options[:migrate]
    @import = options[:import]

    if source == "" || source.nil?
      Dir[Rails.root.join('tmp/scaffolding/*')].each do |source|
        Scaffolding::Build.new(source, name, @auto, @migrate, @import).time("stack")
      end
    else
      Scaffolding::Build.new(source, name, @auto, @migrate, @import).time("stack")
    end
  end

end
