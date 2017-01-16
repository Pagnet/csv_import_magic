module CsvImportMagic
  module Models
    def csv_import_magic(csv_parser)
      define_method(:csv_parser_name) { csv_parser.to_s.classify.constantize }
      define_singleton_method(:columns_names) { new.attributes.keys }
    end
  end
end
