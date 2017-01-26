require 'rails/generators/named_base'

module CsvImportMagic
  module Generators
    class CsvImportMagicGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      namespace 'csv_import_magic'
      source_root File.expand_path('../templates', __FILE__)

      desc 'Generates a model with the given NAME (if one does not exist) with csv_import_magic ' \
           'configuration plus a migration file.'

      hook_for :orm
    end
  end
end
