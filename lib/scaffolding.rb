require "scaffolding/version"

module Scaffolding
  require 'scaffolding/railtie' if defined?(Rails)
  require 'pry'
  binding.pry

  def self.build(file)
    results = Scaffolding::Importer::Excel.process(file)
    if results.kind_of?(Array)
      results.each do |error|
        puts "\e[31m#{error}\e[0m"
      end
      puts ""
    else
      exec results.to_s
    end
  end
end

require 'scaffolding/importer/base'
require 'scaffolding/importer/excel'
