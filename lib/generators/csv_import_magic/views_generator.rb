require 'rails/generators/base'

module CsvImportMagic
  module Generators
    module ViewPathTemplates #:nodoc:
      extend ActiveSupport::Concern

      included do
        argument :scope, required: true, default: nil,
                         desc: "The scope to copy views to"

        class_option :importable_type, aliases: "-i", type: :string, desc: "Select specific importable to importer_csv partial form"
      end

      protected

      def view_directory(name)
        directory name.to_s, target_path do |content|
          content = content.gsub('source_value', scope)

          if options[:importable_type].present?
            content = content.gsub('importable_type_value', options[:importable_type].camelize)
          end

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

    class SharedViewsGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path("../../templates/views", __FILE__)
      desc "Copies shared Csv Magic Import views to your application."
      hide!

      def copy_views
        view_directory :shareds
      end
    end

    class ViewsGenerator < Rails::Generators::Base
      desc "Copies CSV Import Magic views to your application."
      argument :scope, required: true, default: nil, desc: "The scope to copy views to"
      invoke SharedViewsGenerator
    end
  end
end
