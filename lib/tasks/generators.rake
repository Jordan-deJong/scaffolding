namespace :scaffolding do
  require 'rails'

  desc "Create a 'tmp/scaffolding' folder for the scaffolding gem."
  task :folder do |t|
    Dir.mkdir(File.join(Rails.root, 'tmp/scaffolding'))
  end

  # desc "Setup a production enviornemnt to import data from the files."
  # task :production do |t|
  #   Dir.mkdir(File.join(Rails.root, 'tmp/scaffolding'))
  # end

end
