$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "csv_import_magic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "csv_import_magic"
  s.version     = CsvImportMagic::VERSION
  s.authors     = ["Saulo Santiago"]
  s.email       = ["saulodasilvasantiago@gmail.com"]
  s.homepage    = "https://github.com/Pagnet/csv_import_magic"
  s.summary     = "Engine for import CSV dynamically by model"
  s.description = "Engine for import CSV dynamically by model"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.2.5'
  s.add_runtime_dependency 'csv-importer', '~> 0.3.1'
  s.add_runtime_dependency 'paperclip', '~> 5.1.0'
  s.add_dependency 'orm_adapter', '~> 0.1'
  s.add_dependency 'simple_form', '~> 3.4.0'
  s.add_dependency 'sidekiq', '~> 4.2.9'
  s.add_dependency 'sass-rails', '~> 5.0.5'

  s.add_development_dependency "sqlite3"
end
