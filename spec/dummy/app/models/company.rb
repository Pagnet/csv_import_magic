class Company < ActiveRecord::Base
  csv_import_magic :company_parser

  validates_numericality_of :number
end
