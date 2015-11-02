require 'spec_helper'

describe "scaffolding parser" do
  it "should predict the correct datatypes." do
    predictor = Scaffolding::Parser::Raw.new("spec/test.txt", "", true, nil).results
    expect(predictor).to eq "Test boolean:boolean string:string integer:integer decimal:decimal date:date time:time datetime:datetime"
  end
end
