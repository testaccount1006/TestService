require 'spec_helper'

describe ApiKey do
  
  it "should create a key, when its saved" do 
  	key = ApiKey.create!
  	key.access_token.should_not be_nil
  end

end
