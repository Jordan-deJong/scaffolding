require 'rails/generators'
require 'rake'
Rails.application.load_tasks
require 'scaffolding'

class ScaffoldingGenerator < Rails::Generators::Base
  argument :file, :type => :string, :default => ""

  def analyize_files
    if file == "" || file.nil?
      Dir[Rails.root.join('tmp/scaffolding/*')].each do |file|
        Scaffolding.generate(file)
      end
    else
      Scaffolding.generate(file)
    end
  end

end
