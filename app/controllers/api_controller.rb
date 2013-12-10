class ApiController < ApplicationController
  
  before_filter :restrict_access


  # API Method to create company
  def create_company
    
    data = JSON.parse(request.raw_post)
    errors = []
    company = Company.new(data["company"])

    if company.valid? 
      company.save
      
      # Loop through persons and apply them
      data["persons"].each do |person|
        begin
          Person.create(:company_id => company.id, :name => person["name"], :title => person["title"])
        rescue 
          errors << "Person with name: '#{person["name"]}' was not saved due to lack of data"
        end
      end

      # Did any issues appear, while creating persons?
      if errors.count == 0
        render json: {result: "OK", message: "success"}.to_json
      else
        Person.where(:company_id => company.id).each { |p| p.destroy }
        company.destroy
        render json: {result: "Error", message: errors.join(',')}.to_json
      end

    else
      render json: {result: "Error", message: company.errors.full_messages.join(',')}.to_json
    end
  end

  # API method to return all companies
  def companies
    render json: Company.all.to_json
  end

  # API method to check connection
  def check_connection
    render json: {:result => "OK"}.to_json
  end

  # API Method to return individual company
  def get_company
    render json: {company: Company.find(params[:id]), persons: Person.where(company_id: params[:id])}.to_json
  end

  # API Method to update company info
  def update_company
    begin
      company = Company.find(params[:id])
      if company.update_attributes(JSON.parse(request.raw_post))
        render json: {result: "OK"}.to_json
      else
        render json: {result: "Error", message: company.errors.full_messages}.to_json
      end
    rescue 
        render json: {result: "Invalid request"}.to_json
    end 
  end


  def attach_passport

  end


  private 


  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end


end
