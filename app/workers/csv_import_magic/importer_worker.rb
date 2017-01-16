module CsvImportMagic
  class ImporterWorker
    include ::Sidekiq::Worker

    sidekiq_options retry: 1

    def perform(importer_id)
      csv_parsed = ::CsvImportMagic::Importer.new(importer_id).call
      CsvImportMagic::Failure.new(csv_parsed, importer_id).generate
    end
  end
end
