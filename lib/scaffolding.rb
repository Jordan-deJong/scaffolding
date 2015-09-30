require "scaffolding/version"

module Scaffolding
  require 'colorize'

  def self.build(file)
    results = Scaffolding::Importer::Excel.process(file)
    if results.kind_of?(Array)
      results.each do |error|
        puts error.red
      end
      puts ""
    else
      exec results.to_s
      #exec
    end
  end
end

require 'scaffolding/importer/base'
require 'scaffolding/importer/excel'
