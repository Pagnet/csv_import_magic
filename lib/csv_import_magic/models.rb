module CsvImportMagic
  module Models
    def csv_import_magic(*columns)
      define_method(:csv_parser_name) { "#{self.class.to_s}Parser".constantize }
      define_singleton_method(:columns_names) { columns }
    end
  end
end
