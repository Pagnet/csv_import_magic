require 'rails/generators/base'

module CsvImportMagic
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      desc 'Copies CSV Import Magic base controller to your application.'
      source_root File.expand_path('../../../../app/controllers/csv_import_magic', __FILE__)

      def copy_base_controller
        template 'base_controller.rb', 'app/controllers/csv_import_magic/base_controller.rb'
      end
    end
  end
end
