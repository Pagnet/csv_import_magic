module CsvImportMagic
  module Generators
    module OrmHelpers
      def model_contents(options)
        "  csv_import_magic :#{options[:columns].join(', :')}"
      end

      private

      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join('app', 'models', "#{file_path}.rb")
      end
    end
  end
end
