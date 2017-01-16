include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :importer do
    attachment { fixture_file_upload(File.join(ENGINE_RAILS_ROOT, 'spec/fixtures/companies.csv')) }
    source 'Company'
    importable { build(:user) }
  end
end
