class Company < ActiveRecord::Base
  attr_accessible :address, :city, :country, :e-mail, :name, :phone

  validates_presence_of :address
  validates_presence_of :name
  validates_presence_of :phone
  validates_presence_of :country
  validates_presence_of :city

end
