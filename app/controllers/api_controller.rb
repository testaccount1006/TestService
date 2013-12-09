class ApiController < ApplicationController
  
  before_filter :restrict_access


  # API Method to create company
  def create_company
    company = Company.new(JSON.parse(request.raw_post))
    if company.valid? 
      company.save
      render json: {result: "OK"}.to_json
    else
      render json: {result: "Error", message: company.errors.full_messages}.to_json
    end
  end

  # API method to return all companies
  def companies
    render json: Company.all.to_json
  end

  # API Method to return individual company
  def get_company
    render json: Company.find(params[:id]).to_json
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
        render json: {result: "Invalid data"}.to_json
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
