class FooParser
  include ::CSVImporter

  model Company

  identifier :name

  column :name, required: true
end
