require 'spec_helper'

class Scaffolding::Parser::Base
  attr_accessor :data
end

describe "scaffolding parser Base" do
  before(:each) do
    @base = Scaffolding::Parser::Base.new("spec/test.txt", "", true, nil)
  end

  it "should clean the name" do
    expect(@base.source_name).to eq "Test"
  end

  it "should find the right column seperator" do
    expect(@base.col_seperator).to eq ","
  end

  it "should convert data into an string" do
    expect(@base.data.is_a?(String)).to eq true
  end

end
