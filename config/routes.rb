TestService::Application.routes.draw do
  
  post "api/create_company"

  get "api/companies"

  get "api/companies/:id" => "api#get_company"

  put "api/update_company/:id" => "api#update_company"

  post "api/attach_passport"

end
