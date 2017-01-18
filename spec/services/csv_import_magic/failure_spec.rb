require 'rails_helper'

RSpec.describe CsvImportMagic::Failure, type: :service do
  let(:csv_parsed) { CsvImportMagic::Importer.new(import.id).call }
  subject { described_class.new(csv_parsed, import.id) }

  describe '#generate' do
    context 'creates and upload the failures file' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies_invalid.csv')) }
      let!(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(name street number neighborhood city state country) }

      it 'when invalid record' do
        expect do
          subject.generate
          import.reload
        end.to change(import, :error).from(nil).to('Alguns registros não foram importados pois contém erros!')

        expect(import.attachment_error).to be_present
      end
    end

    context 'when invalid file' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let!(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(ignore street number neighborhood city state country) }

      it 'add error on importer' do
        expect do
          subject.generate
          import.reload
        end.to change(import, :error).from(nil).to('Esta faltando a coluna Nome')

        expect(import.attachment_error).to be_blank
      end
    end
  end
end
