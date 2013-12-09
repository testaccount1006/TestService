require 'spec_helper'

describe Company do

	describe "create_company method" do 

		it "accept a user with only necessary data assigned" do 
			company = Company.new(:address => "Address", :city => "Some city", :country => "DK", :name => "TEST A/S")
			company.valid?.should == true
		end
		
		it "should reject if not all data present" do 
			company = Company.new(:address => "Address", :country => "DK", :name => "TEST A/S")
			company.valid?.should == false
		end

		it "should validate the format of email" do 
			company = Company.new(:address => "Address", :city => "Some city", :country => "DK", :name => "TEST A/S", :email => "test@test.dk")
			company.valid?.should == true

			company.email = "test.dk"
			company.valid?.should == false
		end
			
	end
end
