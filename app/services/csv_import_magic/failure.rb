module CsvImportMagic
  class Failure
    attr_reader :rows, :report, :csv_parsed, :importer, :identifier

    def initialize(csv_parsed, importer_id)
      @importer = ::Importer.find(importer_id)
      @csv_parsed = csv_parsed
      @report = csv_parsed.report
      @rows = report.invalid_rows
      @identifier = csv_parsed.config.identifiers.first
    end

    def generate
      set_message_to_header_error unless csv_parsed.valid_header?

      if rows.present?
        CSV.open(tmp_failures_file.path, 'wb', col_sep: ';') do |csv|
          append_header(csv)
          append_records(csv)
        end

        set_attachement_error
      end
    end

    private

    def set_attachement_error
      importer.attachment_error = tmp_failures_file
      importer.error = 'Alguns registro não foram importados pois possuem erros!'
      importer.save!
    end

    def set_message_to_header_error
      columns_translated = report.missing_columns.map do |column|
        column = importer.source_klass.human_attribute_name(column)
      end.to_sentence

      importer.update(error: "Esta faltando as seguintes colunas: #{columns_translated}")
    end

    def tmp_failures_file
      @file ||= Tempfile.new(["failures", '.csv'])
    end

    def append_header(csv)
      identifier_translated = importer.source_klass.human_attribute_name(identifier)
      csv << [identifier_translated, 'Erros']
    end

    def append_records(csv)
      rows.each do |row|
        record = row.model
        csv << [record.send(identifier), record.errors.full_messages.to_sentence]
      end
    end
  end
end
