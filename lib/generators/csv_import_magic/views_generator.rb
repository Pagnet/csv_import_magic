require 'rails/generators/base'

module CsvImportMagic
  module Generators
    module ViewPathTemplates #:nodoc:
      extend ActiveSupport::Concern

      included do
        argument :scope, required: true, default: nil,
                         desc: 'The scope to copy views to'

        class_option :importable_type, aliases: '-i', type: :string, desc: 'Select specific importable to importer_csv partial form'
      end

      protected

      def view_directory(name)
        directory name.to_s, target_path do |content|
          content = content.gsub('source_value', scope)
          content
        end
      end

      def target_path
        @target_path ||= "app/views/#{plural_scope}"
      end

      def plural_scope
        @plural_scope ||= scope.presence && scope.underscore.pluralize
      end
    end

    class LayoutViewsGenerator < Rails::Generators::Base #:nodoc:
      source_root File.expand_path('../../../../app/views', __FILE__)
      desc 'Copies shared Csv Magic Import Layout to your application.'

      def copy_layout_views
        directory :layouts, 'app/views/layouts'
      end

      def copy_views
        directory 'csv_import_magic/importers', 'app/views/csv_import_magic/importers'
      end
    end

    class SharedViewsGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path('../../templates/views', __FILE__)
      desc 'Copies shared Csv Magic Import Partial views to your application.'
      hide!

      def copy_views
        view_directory :shareds
      end
    end

    class ViewsGenerator < Rails::Generators::Base
      desc 'Copies CSV Import Magic views to your application.'
      argument :scope, required: true, default: nil, desc: 'The scope to copy views to'

      invoke LayoutViewsGenerator
      invoke SharedViewsGenerator
    end
  end
end
