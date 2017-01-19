require 'rails_helper'

RSpec.describe CsvImportMagic::ImporterWorker, type: :worker do
  let(:worker) { described_class.new }
  let!(:importer) { create :importer }

  describe '#perform' do
    let(:report) { double(CSVImporter::Report, created_rows: [1, 2], updated_rows: [], invalid_rows: []) }
    let(:config) { double(:config, identifiers: [:foo]) }
    let(:csv_parsed) { double(CompanyParser, report: report, config: config, valid_header?: true) }
    let(:service) { double(CsvImportMagic::Importer, call: csv_parsed) }
    let(:failures) { double(CsvImportMagic::Failure, generate: true) }

    before do
      instance_of_importer = double
      allow(CsvImportMagic::Importer).to receive(:new).with(importer.id, nil).and_return(instance_of_importer)
      allow(instance_of_importer).to receive(:call).and_return(csv_parsed)
    end

    it 'calls CsvImportMagic::Importer service' do
      expect(CsvImportMagic::Importer).to receive(:new).with(importer.id, nil).and_return(service)
      worker.perform({importer_id: importer.id, resources: nil})
    end

    it 'calls CsvImportMagic::Failure service' do
      expect(CsvImportMagic::Failure).to receive(:new).with(csv_parsed, importer.id).and_return(failures)
      expect(failures).to receive(:generate)
      worker.perform({importer_id: importer.id, resources: nil})
    end
  end
end
