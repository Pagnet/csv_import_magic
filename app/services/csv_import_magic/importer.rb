module CsvImportMagic
  class Importer
    attr_reader :source_klass, :importer, :csv_parser_class, :resources

    def initialize(importer_id, resources = nil)
      @importer = ::Importer.find(importer_id)
      @source_klass = importer.source_klass
      @csv_parser_class = importer.parser_klass
      @resources = resources.try(:symbolize_keys!)
      @model = model_with_relation || @source_klass
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

    def model_with_relation
      return if resources.blank?
      resources[:model].classify.constantize.find(resources[:id]).send(resources[:relation])
    end

    def csv_parsed
      model = @model

      @csv_parsed ||= csv_parser_class.new(content: content_with_new_header) do
        model model
      end
    end

    def content
      @content ||= begin
        content = Paperclip.io_adapters.for(@importer.attachment).read.force_encoding('UTF-8')
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
