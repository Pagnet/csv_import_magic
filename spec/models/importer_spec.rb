require 'rails_helper'

RSpec.describe Importer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:source) }
    it { is_expected.to have_attached_file(:attachment) }
    it { is_expected.to validate_attachment_presence(:attachment) }
    it { is_expected.to validate_attachment_content_type(:attachment).
                allowing('text/plain', 'text/csv', 'application/vnd.ms-excel').
                rejecting('image/png', 'image/gif', 'text/xml') }

    it { is_expected.to have_attached_file(:attachment_error) }
    it { is_expected.to validate_attachment_content_type(:attachment_error).
                allowing('text/plain', 'text/csv', 'application/vnd.ms-excel').
                rejecting('image/png', 'image/gif', 'text/xml') }

    context '#has_no_duplicate_columns' do
      it 'not accept the same column name unless is ignore' do
        expect(build(:importer, columns: %w(ignore ignore foo bar))).to be_valid
        expect(build(:importer, columns: %w(ignore ignore foo foo))).to be_invalid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:importable) }
  end

  context '#source_klass' do
    let(:importer) { create(:importer, source: 'company') }

    it { expect(importer.source_klass).to eq(Company) }
  end

  context '#importable_columns' do
    let(:importer) { create(:importer, source: 'company') }
    it { expect(importer.importable_columns).to eq(%w(id name street number neighborhood city state country active)) }
  end
end
