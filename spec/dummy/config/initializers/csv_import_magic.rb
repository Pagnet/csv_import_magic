CsvImportMagic.setup do |config|
  config.after_create_redirect_with_error = '/'
  config.after_update_redirect_with_success = '/'
end
