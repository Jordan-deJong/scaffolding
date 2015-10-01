require "scaffolding/version"

module Scaffolding
  require 'scaffolding/railtie' if defined?(Rails)

  def self.build(file)
    Scaffolding::Parser::Excel.process(file)
  end
end

require 'scaffolding/parser/base'
require 'scaffolding/parser/excel'
