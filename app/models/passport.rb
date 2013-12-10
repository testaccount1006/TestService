class Passport < ActiveRecord::Base
  attr_accessible :description, :passport, :person_id
end
