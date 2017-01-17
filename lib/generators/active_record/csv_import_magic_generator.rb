require 'rails/generators/active_record'
require 'generators/csv_import_magic/orm_helpers'

module ActiveRecord
  module Generators
    class CsvImportMagicGenerator < ActiveRecord::Generators::Base
      include CsvImportMagic::Generators::OrmHelpers

      source_root File.expand_path("../templates", __FILE__)

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke

        class_path = if name.match(/\:\:/).present?
          name.to_s.gsub('::', '/')
        else
          name
        end

        template 'csv_parser.rb', "app/csv_parsers/#{class_path}_parser.rb"
      end

      def inject_csv_import_magic_content
        content = model_contents
        class_path = [class_name]

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end
    end
  end
end
