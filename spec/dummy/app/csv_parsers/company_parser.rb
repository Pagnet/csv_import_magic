class CompanyParser
  include ::CSVImporter

  model Company

  identifier :name

  column :name, required: true
  column :number, required: true
  column :city, required: true
  column :state, required: true
  column :street
  column :neighborhood
  column :country
end
