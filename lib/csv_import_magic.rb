require 'paperclip'
require 'orm_adapter'
require 'simple_form'
require 'csv-importer'
require 'sidekiq'

require "csv_import_magic/engine"
require "csv_import_magic/models"
require "csv_import_magic/orm/active_record"

module CsvImportMagic
  mattr_accessor :after_create_redirect_with_error
  @@after_create_redirect_with_error = {}


  mattr_accessor :after_update_redirect_with_success
  @@after_update_redirect_with_success = {}

  def self.setup
    yield self
  end
end
