namespace :scaffolding do
  require 'rails'

  desc "Create a 'tmp/scaffolding' folder for the scaffolding gem."
  task :folder do |t|
    Dir.mkdir(File.join(Rails.root, 'tmp/scaffolding'))
  end

  desc "Setup a production enviornemnt to import data from the files."
  task :production do |t|
    generators = Rails::Generators::Base.new
    generators.generate "controller", "scaffolding new --skip --skip-routes"
    generators.route "get 'scaffolding/new'"
    generators.route "post 'scaffolding/import'"

    File.open(File.join(Rails.root, "app/views/scaffolding/new.html.erb"), 'w') {|f| f.write(
"<div class='authform'>
  <%= form_tag scaffolding_import_path, multipart: true do %>
    <%= file_field_tag :file %>
    <br>
    <%= submit_tag 'Import', class: 'button-xs' %>
  <% end %>
</div>"
      ) }

    File.open(File.join(Rails.root, "app/controllers/scaffolding_controller.rb"), 'w') {|f| f.write(
"class ScaffoldingController < ApplicationController
  def new
  end
  def import
    name = params[:file].original_filename.downcase.gsub(File.extname(params[:file].path), "")
    results = Scaffolding::Build.new(params[:file], name.singularize, true, false, true).import_bowser_data
    if results.kind_of?(Array)
     flash[:alert] = results
     else
      flash[:notice] = '\#{results[:saved]} records saved, \#{results[:failed]} results failed.'
    end
    redirect_to "/" + (name.ends_with?("s") ? name : name.pluralize)
  end
end
"
      ) }
  end

end
