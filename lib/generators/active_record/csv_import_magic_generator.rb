require 'rails/generators/active_record'
require 'generators/csv_import_magic/orm_helpers'

module ActiveRecord
  module Generators
    class CsvImportMagicGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      class_option :columns, aliases: '-c', type: :array, required: true, desc: "Select specific columns yout want parser"

      include CsvImportMagic::Generators::OrmHelpers

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
        content = model_contents(options)
        class_path = [class_name]

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end
    end
  end
end
