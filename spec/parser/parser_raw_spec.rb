require 'spec_helper'

class Scaffolding::Parser::Base
  attr_accessor :column_count, :headers
end

describe "scaffolding parser Raw" do
  before(:each) do
    @raw = Scaffolding::Parser::Raw.new("spec/test.txt", "", true, nil)
    @raw.groom_data
  end

  it "should convert data into array" do
    expect(@raw.data.is_a?(Array)).to eq true
  end

  it "should count to columns" do
    expect(@raw.column_count).to eq 7
  end

  it "should set the headers" do
    expect(@raw.headers).to eq ["boolean", "string", "integer", "decimal", "date", "time", "datetime"]
  end

  it "should turn data into a array of hashes" do
    expect(@raw.data.first.is_a?(Hash)).to eq true
  end


end
