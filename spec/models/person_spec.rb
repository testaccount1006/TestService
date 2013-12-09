require 'spec_helper'

describe Person do
	
	it "should be valid if data are correct" do 
		person = Person.new(:company_id => 1, :name => "Mathias", :title => "Director")
		person.valid?.should == true
	end

	it "should be invalid if an attribute is missing" do 
		person = Person.new(:company_id => 1, :name => "Mathias")
		person.valid?.should == false
	end
	
end
