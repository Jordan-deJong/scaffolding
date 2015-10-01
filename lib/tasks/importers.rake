namespace :import do
  namespace :csv do
    desc 'Import data from CSV file'
    task :data do |t|
      Scaffolding.import_data
    end
  end
end
