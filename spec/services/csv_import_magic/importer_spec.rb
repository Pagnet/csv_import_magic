require 'rails_helper'

RSpec.describe CsvImportMagic::Importer, type: :service do
  let(:importer) { described_class.new(import.id) }

  describe '#call' do
    context 'with valid columns' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(name street number neighborhood city state country) }

      it 'create an company for every row' do
        expect { importer.call }.to change(Company, :count).by(2)
        expect(Company.all.pluck(:name)).to match_array(['bar', 'foo'])
        expect(Company.all.pluck(:street)).to match_array(['R: Teste', 'R: Teste'])
        expect(Company.all.pluck(:number)).to match_array(['1', '2'])
        expect(Company.all.pluck(:neighborhood)).to match_array(['Joao de Barro', 'Joao de Barro'])
        expect(Company.all.pluck(:city)).to match_array(['Aracatuba', 'Birigui'])
        expect(Company.all.pluck(:state)).to match_array(['SP', 'SP'])
      end
    end

    context 'with ignored columns' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(name street number ignore city state country) }

      it 'create an company for every row' do
        expect { importer.call }.to change(Company, :count).by(2)
        expect(Company.all.pluck(:name)).to match_array(['bar', 'foo'])
        expect(Company.all.pluck(:street)).to match_array(['R: Teste', 'R: Teste'])
        expect(Company.all.pluck(:number)).to match_array(['1', '2'])
        expect(Company.all.pluck(:neighborhood)).to match_array([nil, nil])
        expect(Company.all.pluck(:city)).to match_array(['Aracatuba', 'Birigui'])
        expect(Company.all.pluck(:state)).to match_array(['SP', 'SP'])
      end
    end
  end
end
