include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :importer do
    attachment { fixture_file_upload(File.join(ENGINE_RAILS_ROOT, 'spec/fixtures/companies.csv')) }
    source 'company'
    columns ['name', 'number', 'city', 'state']
    importable { build(:user) }
  end
end
