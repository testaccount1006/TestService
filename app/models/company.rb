class Company < ActiveRecord::Base

  attr_accessible :address, :city, :country, :email, :name, :phone

  # Versioned with vestal
  versioned

  # Validations
  validates_presence_of :address, :city, :country, :name
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_nil => true


end
