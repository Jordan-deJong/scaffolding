require 'spec_helper'

describe "scaffolding parser Base" do
  before(:each) do
    @base = Scaffolding::Parser::Base.new("spec/test.txt", "", true, nil)
  end

  it "should clean the name" do
    @base.clean_source_name
    expect(@base.source_name).to eq "Test"
  end

  it "should fins the right column seperator" do
    expect(@base.col_seperator).to eq ","
  end

  it "should predict the a string" do
    expect(@base.predict_row(row)).to eq ""
  end
end
