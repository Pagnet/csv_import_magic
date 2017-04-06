require 'rails_helper'

RSpec.describe CsvImportMagic::Importer, type: :service do
  let(:importer) { described_class.new(import.id) }

  describe '#call' do
    context 'with additional_data' do
      let(:additional_data) { '{"one_additional_attribute": "importer-attr", "other_additional_attribute": "other-importer-attr"}' }
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let(:import) do
        create :importer, attachment: attachment, source: 'company', columns: %w(name street number neighborhood city state country), additional_data: additional_data
      end

      it 'create an company for every row with the same additional_data' do
        expect { importer.call }.to change(Company, :count).by(2)
        expect(Company.all.pluck(:one_additional_attribute)).to match_array(%w(importer-attr importer-attr))
        expect(Company.all.pluck(:other_additional_attribute)).to match_array(%w(other-importer-attr other-importer-attr))
      end
    end

    context 'with resource params' do
      let!(:user) { create(:user) }
      let(:importer) { described_class.new(import.id, model: 'User', id: user.id, relation: 'companies') }
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(name street number neighborhood city state country) }

      it 'create an company for every row, with relation' do
        expect { importer.call }.to change(Company, :count).by(2)
        expect(Company.all.pluck(:name)).to match_array(%w(bar foo))
        expect(Company.all.pluck(:street)).to match_array(['R: Teste', 'R: Teste'])
        expect(Company.all.pluck(:number)).to match_array(%w(1 2))
        expect(Company.all.pluck(:neighborhood)).to match_array(['Joao de Barro', 'Joao de Barro'])
        expect(Company.all.pluck(:city)).to match_array(%w(Aracatuba Birigui))
        expect(Company.all.pluck(:state)).to match_array(%w(SP SP))
        expect(Company.all.pluck(:user_id)).to match_array([user.id, user.id])
      end
    end

    context 'with valid columns' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(name street number neighborhood city state country) }

      it 'create an company for every row' do
        expect { importer.call }.to change(Company, :count).by(2)
        expect(Company.all.pluck(:name)).to match_array(%w(bar foo))
        expect(Company.all.pluck(:street)).to match_array(['R: Teste', 'R: Teste'])
        expect(Company.all.pluck(:number)).to match_array(%w(1 2))
        expect(Company.all.pluck(:neighborhood)).to match_array(['Joao de Barro', 'Joao de Barro'])
        expect(Company.all.pluck(:city)).to match_array(%w(Aracatuba Birigui))
        expect(Company.all.pluck(:state)).to match_array(%w(SP SP))
        expect(Company.all.pluck(:user_id)).to match_array([nil, nil])
      end
    end

    context 'with ignored columns' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }
      let(:import) { create :importer, attachment: attachment, source: 'company', columns: %w(name street number ignore city state country) }

      it 'create an company for every row' do
        expect { importer.call }.to change(Company, :count).by(2)
        expect(Company.all.pluck(:name)).to match_array(%w(bar foo))
        expect(Company.all.pluck(:street)).to match_array(['R: Teste', 'R: Teste'])
        expect(Company.all.pluck(:number)).to match_array(%w(1 2))
        expect(Company.all.pluck(:neighborhood)).to match_array([nil, nil])
        expect(Company.all.pluck(:city)).to match_array(%w(Aracatuba Birigui))
        expect(Company.all.pluck(:state)).to match_array(%w(SP SP))
        expect(Company.all.pluck(:user_id)).to match_array([nil, nil])
      end
    end
  end
end
