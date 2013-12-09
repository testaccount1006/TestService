require 'spec_helper'

describe ApiController do

  before(:each) do 
    @company = Company.create(:address => "test", :city => "Test", :country => "Germany", :name => "Test")
    @company2 = Company.create(:address => "test2", :city => "Test2", :country => "Germany2", :name => "Test2")
  end

  describe "POST 'create_company'" do

    it "requires authentication" do
      post 'create_company'
      response.response_code.should == 401
    end

    it "should report an error if necessary data is missing" do 
      data = {
          :address => "Test street 22",
          :city => "Silkeborg", 
          :country => "Denmark"
      }
      request.env['RAW_POST_DATA'] = data.to_json
      authenticate
      post :create_company

      response.response_code.should == 200

      res = JSON.parse(response.body)
      res["result"].should == "Error"
    end
    
    it "should be able to create a company" do 
      data = {
          :address => "Test street 22",
          :city => "Silkeborg", 
          :country => "Denmark",
          :name => "Test"
      }
      request.env['RAW_POST_DATA'] = data.to_json
      authenticate
      post :create_company

      response.response_code.should == 200

      res = JSON.parse(response.body)
      res["result"].should == "OK"
    end


  end

  describe "GET 'companies'" do
    
    it "returns http success" do
      authenticate
      get 'companies'
      response.should be_success
    end
    
    it "should require authentication" do 
      get 'companies'
      response.response_code.should == 401
    end

    it "should return all companies" do 
      authenticate
      get 'companies'
      res = JSON.parse(response.body)
      res.count.should == Company.all.count
    end

  end

  describe "GET 'get_company'" do
    it "returns http success" do
      authenticate
      get 'get_company', :id => @company.id
      response.should be_success
    end

    it "should return appropriate company data" do 
      authenticate
      get 'get_company', :id => @company.id
      data = JSON.parse(response.body)
      data["address"].should == @company.address
      data["email"].should == @company.email
      data["phone"].should == @company.phone
      data["city"].should == @company.city
      data["country"].should == @company.country
    end
  end

  describe "PUT 'update_company'" do

    it "should require authentication" do 
      put "update_company", :id => @company.id
      response.response_code.should == 401
    end

    it "returns result OK when update" do
      authenticate
      data = {
          :address => "Test street 23",
          :city => "Silkeborg", 
          :country => "Denmark",
          :name => "Test"
      }
      request.env['RAW_POST_DATA'] = data.to_json      
      put "update_company", :id => @company.id
      response.should be_success
      
      res = JSON.parse(response.body)
      res["result"].should == "OK"
    end

    it "should throw error if email is not in correct format" do 
      authenticate
      data = {
        :email => "test"
      }
      request.env['RAW_POST_DATA'] = data.to_json  
      put "update_company", :id => @company.id

      res = JSON.parse(response.body)
      res["result"].should == "Error"
    end
  end

  describe "GET 'attach_passport'" do
    it "returns http success" do
      get 'attach_passport'
      response.should be_success
    end
  end

end
