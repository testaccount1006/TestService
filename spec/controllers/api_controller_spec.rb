require 'spec_helper'

describe ApiController do

  before(:each) do 
    @company = Company.create(:address => "test", :city => "Test", :country => "Germany", :name => "Test")
    @company2 = Company.create(:address => "test2", :city => "Test2", :country => "Germany2", :name => "Test2")

    @person = Person.create(:company_id => @company.id, :name => "Hans Jensen", :title => "Director")
  end

  describe "GET 'check_connection'" do 
     it "should require authentication" do 
        get :check_connection
        response.response_code.should == 401
     end

     it "should return OK, when connection established" do 
        authenticate
        get :check_connection
        response.response_code.should == 200
        JSON.parse(response.body)["result"].should == "OK"
     end
  end
 
  describe "POST 'create_company'" do

    it "requires authentication" do
      post 'create_company'
      response.response_code.should == 401
    end

    it "should report an error if necessary data is missing" do 
      data = {
          :company => {:address => "Test street 22",
                       :city => "Silkeborg", 
                       :country => "Denmark"},
          :persons => [{:name => "Mathias Salomonsson",
                        :title => "Director"}]
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
          :company => { :address => "Test street 22",
                        :city => "Silkeborg", 
                        :country => "Denmark",
                        :name => "Test"},
          :persons => [{:name => "Mathias Salomonsson",
                        :title => "Director"}]
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
      data["company"]["address"].should == @company.address
      data["company"]["email"].should == @company.email
      data["company"]["phone"].should == @company.phone
      data["company"]["city"].should == @company.city
      data["company"]["country"].should == @company.country
      data["persons"][0]["name"].should == @person.name
      data["persons"][0]["title"].should == @person.title
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

  describe "POST 'attach_passport'" do
    it "requires authentication" do
      post 'attach_passport', :id => @person.id
      response.response_code.should == 401
    end

    it "should upload file" do 
      authenticate
      encoded_file = Base64.encode64(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'test_image.png'))).read)
      data = {file: encoded_file, filename: "testfile.png"}
      request.env['RAW_POST_DATA'] = data.to_json  
      post 'attach_passport', :id => @person.id
      response.should be_success
    end
    
  end

end
