Rails.application.routes.draw do
  root to: 'application#index'

  mount CsvImportMagic::Engine => '/csv_import_magic'
end
