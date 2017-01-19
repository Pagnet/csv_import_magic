require 'rails_helper'

RSpec.describe CsvImportMagic::Models, type: :lib do
  let!(:fake_model) do
    class FooParser
    end

    instance_of_class = Class.new do
      extend CsvImportMagic::Models
      csv_import_magic :foo, :bar
    end

    Object.const_set('Foo', instance_of_class)
  end

  describe '#csv_parser_name' do
    it { expect(fake_model.new.csv_parser_name).to eq(FooParser) }
  end

  describe '#columns_names' do
    it { expect(fake_model.columns_names).to match_array([:foo, :bar]) }
  end
end
