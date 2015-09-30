require "scaffolding/version"

module Scaffolding
  require 'colorize'

  def self.build(file)
    #'C:\Users\jdejong\Desktop\Windows.csv'
    result = Scaffolding::Importer::Excel.process(file).to_s
    puts result
    # exec result
  end
end

require 'scaffolding/importer/base'
require 'scaffolding/importer/excel'
