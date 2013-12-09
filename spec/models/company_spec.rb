require 'spec_helper'

describe Company do

	describe "create_company method" do 

		it "should reject if no authentication token is used" do 
			post :create_company
			response.response_code.should == 401
		end
		
		it "should reject if not all data present" do 
			data = {
				:name => "Test company",
				:address => "Test address", 
				:city => "Aarhus"
			}	
			
			request.env['RAW_POST_DATA'] = data.to_json
			post :create_company
			response.response_code.should == 500
		end
			
	end
end
