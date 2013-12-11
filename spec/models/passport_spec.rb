require 'spec_helper'

describe Passport do
  it "should validate binary data and description" do 
  	p = Passport.new(:description => "test")
  	p.valid?.should == false
  	passport = Passport.new(:passport => "test")
  	passport.valid?.should == false
  end
end
