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
      set_message_to_success
      set_attachement_error
    end

    private

    def set_message_to_success
      return if !csv_parsed.valid_header? || rows.present?

      importer.update(status: 'success', message: I18n.t('csv_import_magic.services.success'))
    end

    def set_attachement_error
      return if rows.blank?

      CSV.open(tmp_failures_file.path, 'wb', col_sep: ';') do |csv|
        append_header(csv)
        append_records(csv)
      end

      importer.update(status: 'error', message: I18n.t('csv_import_magic.services.failure.records_error'), attachment_error: tmp_failures_file)
    end

    def tmp_failures_file
      @file ||= Tempfile.new(["failures", '.csv'])
    end

    def append_header(csv)
      csv << rows.first.header.column_names.map do |column_name|
        importer.source_klass.human_attribute_name(column_name)
      end + [I18n.t('csv_import_magic.services.error_label')]
    end

    def append_records(csv)
      rows.each do |row|
        record = row.model
        csv << row.row_array + [record.errors.full_messages.to_sentence]
      end
    end
  end
end
