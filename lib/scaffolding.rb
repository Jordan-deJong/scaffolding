require "scaffolding/version"

module Scaffolding
  require 'scaffolding/railtie' if defined?(Rails)

  def self.generate(file)
    Scaffolding::Parser::Csv.process(file)
  end
end

require 'scaffolding/parser/base'
require 'scaffolding/parser/csv'
