require 'rails_helper'

RSpec.describe CsvImportMagic::Models, type: :lib do
  let!(:fake_model) do
    Class.new do
      extend CsvImportMagic::Models

      csv_import_magic :company

      def attributes
        {foo: 'bar', bar: 'foo'}
      end
    end
  end

  describe '#csv_parser_name' do
    it { expect(fake_model.new.csv_parser_name).to eq(Company) }
  end

  describe '#columns_names' do
    it { expect(fake_model.columns_names).to match_array([:foo, :bar]) }
  end
end
