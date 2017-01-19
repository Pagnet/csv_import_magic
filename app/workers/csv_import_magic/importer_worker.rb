module CsvImportMagic
  class ImporterWorker
    include ::Sidekiq::Worker

    sidekiq_options retry: 1

    def perform(options)
      options.symbolize_keys!
      csv_parsed = ::CsvImportMagic::Importer.new(options[:importer_id], options[:resources]).call
      CsvImportMagic::Failure.new(csv_parsed, options[:importer_id]).generate
    end
  end
end
