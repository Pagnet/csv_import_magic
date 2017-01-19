class Company < ActiveRecord::Base
  csv_import_magic :name, :street, :number, :neighborhood, :city, :state, :country

  validates_numericality_of :number
end
