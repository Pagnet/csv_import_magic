require 'rails_helper'

RSpec.describe Importer, type: :model do
  describe 'validations' do
    subject { build(:importer, parser: 'company_parser') }

    it { is_expected.to validate_presence_of(:source) }
    it { is_expected.to validate_inclusion_of(:status).in_array(%w(pending success error)) }
    it { is_expected.to have_attached_file(:attachment) }
    it { is_expected.to validate_attachment_presence(:attachment) }
    it do
      is_expected.to validate_attachment_content_type(:attachment)
        .allowing('text/plain', 'text/csv', 'application/vnd.ms-excel')
        .rejecting('image/png', 'image/gif', 'text/xml')
    end

    it { is_expected.to have_attached_file(:attachment_error) }
    it do
      is_expected.to validate_attachment_content_type(:attachment_error)
        .allowing('text/plain', 'text/csv', 'application/vnd.ms-excel')
        .rejecting('image/png', 'image/gif', 'text/xml')
    end

    context '#uniqueness_columns' do
      it 'not accept the same column name unless is ignore' do
        expect(build(:importer, columns: %w(name number city state))).to be_valid
        expect(build(:importer, columns: %w(name number city state state))).to be_invalid
      end
    end

    context '#required_columns' do
      it 'not accept no select columns are required' do
        importer = create(:importer, columns: [])

        importer.columns = %w(name number city state)
        expect(importer).to be_valid

        importer.columns = %w(name number city ignore)
        expect(importer).to be_invalid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:importable) }
  end

  describe 'callbacks' do
    context '.before_validation #set_parser' do
      let(:importer) { build(:importer, parser: nil) }

      it 'set default parser when nil' do
        expect do
          importer.save
          importer.reload
        end.to change(importer, :parser).from(nil).to('company_parser')
      end

      it 'not change when parser is present' do
        class Foo
        end

        expect do
          importer.parser = 'foo_parser'
          importer.save
          importer.reload
        end.to change(importer, :parser).to('foo_parser')
      end
    end
  end

  context '#source_klass' do
    let(:importer) { create(:importer, source: 'company') }

    it { expect(importer.source_klass).to eq(Company) }
  end

  context '#importable_columns' do
    let(:importer) { create(:importer, source: 'company') }
    it { expect(importer.importable_columns).to match_array([:name, :street, :number, :neighborhood, :city, :state, :country]) }
  end

  context '#human_attribute_name' do
    let(:importer) { create(:importer, source: 'company') }
    column = 'name'
    context 'without a translation set' do
      it 'defaults to source_klass human_attribute_name' do
        expect(importer.human_attribute_name(column)).to eq(importer.source_klass.human_attribute_name(column))
      end
    end

    context 'with a translation set' do
      it 'returns scoped translation' do
        allow(I18n).to receive(:translate)
        allow(I18n).to receive(:translate).with(:"activemodel.attributes.company.csv_import_magic.name", default: importer.source_klass.human_attribute_name(column)).and_return('scoped transalation')
        expect(importer.human_attribute_name(column)).to eq('scoped transalation')
      end
    end
  end
end
