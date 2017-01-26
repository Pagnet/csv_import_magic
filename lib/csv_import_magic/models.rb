module CsvImportMagic
  module Models
    def csv_import_magic(options)
      define_method(:csv_parser_names) do
        names_of_parsers = {}

        options.each do |key, _value|
          names_of_parsers["#{key}_parser"] = "#{key.to_s.classify}Parser".constantize
        end

        names_of_parsers
      end

      define_singleton_method(:csv_parser_default_name) { "#{name.to_s.underscore}_parser" }
      define_singleton_method(:columns_names) { |param| options[param.to_s.remove('_parser').to_sym] }
    end
  end
end
