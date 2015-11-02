require 'spec_helper'

describe "scaffolding parser" do
  it "should predict the correct datatypes." do
    predictor = Scaffolding::Parser::Raw.new("test.txt", "", true, false).results
    predictor.should == "boolean:boolean, string:string, integer:integer, decimal:decimal, date:date, time:time, datetime:datetime"
  end
end
