CsvImportMagic.setup do |config|
  # When importer has errors, redirect for this path
  config.after_create_redirect_with_error = '/'

  # When importer has imported with success, redirect for this path
  config.after_update_redirect_with_success = '/'
end
