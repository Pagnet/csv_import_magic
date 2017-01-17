module CsvImportMagic
  module Generators
    module OrmHelpers
      def model_contents
        "  csv_import_magic :#{file_path}"
      end

      private

      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
