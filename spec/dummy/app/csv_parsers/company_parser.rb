class CompanyParser
  include ::CSVImporter

  model Company

  identifier :name

  column :name, required: true
  column :street
  column :number, required: true
  column :neighborhood
  column :city, required: true
  column :state, required: true
  column :country
end
