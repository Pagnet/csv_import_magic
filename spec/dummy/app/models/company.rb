class Company < ActiveRecord::Base
  csv_import_magic company: [:name, :street, :number, :neighborhood, :city, :state, :country]


  validates_numericality_of :number
end
