class Passport < ActiveRecord::Base
 
  attr_accessible :description, :passport, :person_id
  
  versioned
  validates_presence_of :description, :passport, :person_id


end
