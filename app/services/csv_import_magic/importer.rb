module CsvImportMagic
  class Importer
    attr_reader :source_klass, :importer, :csv_parser_class

    def initialize(importer_id)
      @importer = ::Importer.find(importer_id)
      @source_klass = importer.source_klass
      @csv_parser_class = source_klass.new.csv_parser_name
    end

    def call
      csv_parsed.run!
      csv_parsed.report
      csv_parsed
    end

    def column_separator
      header = content.lines("\r")[0].gsub(/[^,;\t]/, '_')
      header.scan(/[,;\t]/).first
    end

    private

    def csv_parsed
      @csv_parsed ||= csv_parser_class.new(content: content_with_new_header)
    end

    def content
      @content ||= begin
        content = open(importer.attachment.path).read.force_encoding('UTF-8')
        content.encode('UTF-8', content.encoding, invalid: :replace, undef: :replace, universal_newline: true)
      end
    end

    def content_with_new_header
      new_header = importer.columns.join("#{column_separator}")

      body = content.lines[1..-1].join
      body.prepend(new_header + "\n")
    end
  end
end
