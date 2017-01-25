require 'rails_helper'

RSpec.describe Importer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:source) }
    it { is_expected.to validate_inclusion_of(:status).in_array(['pending', 'success', 'error']) }
    it { is_expected.to have_attached_file(:attachment) }
    it { is_expected.to validate_attachment_presence(:attachment) }
    it { is_expected.to validate_attachment_content_type(:attachment).
                allowing('text/plain', 'text/csv', 'application/vnd.ms-excel').
                rejecting('image/png', 'image/gif', 'text/xml') }

    it { is_expected.to have_attached_file(:attachment_error) }
    it { is_expected.to validate_attachment_content_type(:attachment_error).
                allowing('text/plain', 'text/csv', 'application/vnd.ms-excel').
                rejecting('image/png', 'image/gif', 'text/xml') }

    context '#columns' do
      it 'not accept the same column name unless is ignore' do
        expect(build(:importer, columns: %w(name street number neighborhood city state country))).to be_valid
        expect(build(:importer, columns: %w(ignore ignore foo bar))).to be_invalid
        expect(build(:importer, columns: %w(ignore ignore foo foo))).to be_invalid
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
        expect do
          importer.parser = 'foo'
          importer.save
          importer.reload
        end.to change(importer, :parser).to('foo')
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
end
