require 'rails_helper'

RSpec.describe CsvImportMagic::Models, type: :lib do
  context 'with normal parser' do
    let(:foo_model) do
      class FooParser; end

      Class.new do
        extend CsvImportMagic::Models
        csv_import_magic foo: [:foo, :bar]

        def self.name
          'Foo'
        end
      end
    end

    describe '#csv_parser_names' do
      it { expect(foo_model.new.csv_parser_names).to eq('foo_parser' => FooParser) }
    end

    describe '#columns_names' do
      it { expect(foo_model.columns_names(:foo)).to match_array([:foo, :bar]) }
    end

    describe '#csv_parser_default_name' do
      it { expect(foo_model.csv_parser_default_name).to eq('foo_parser') }
    end
  end

  context 'with multiple parser' do
    let(:bar_model) do
      class BarParser; end
      class FooParser; end

      Class.new do
        extend CsvImportMagic::Models
        csv_import_magic foo: [:foo, :bar], bar: [:foo]
      end
    end

    describe '#csv_parser_names' do
      it { expect(bar_model.new.csv_parser_names).to eq('foo_parser' => FooParser, 'bar_parser' => BarParser) }
    end

    describe '#columns_names' do
      it { expect(bar_model.columns_names(:foo)).to match_array([:foo, :bar]) }
      it { expect(bar_model.columns_names(:bar)).to match_array([:foo]) }
    end
  end
end
