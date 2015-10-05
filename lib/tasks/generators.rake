namespace :scaffolding do
  desc "Create a 'tmp/scaffolding' folder for the scaffolding gem."
  task :folder do |t|
    require 'rails'
    Dir.mkdir(File.join(Rails.root, 'tmp/scaffolding'))
  end
end
