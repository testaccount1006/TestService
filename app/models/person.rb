class Person < ActiveRecord::Base
  attr_accessible :company_id, :name, :title

  # Versioned with vestal
  versioned

  # Validate
  validates_presence_of :company_id, :name, :title

  # Relates to company
  belongs_to :company

end
