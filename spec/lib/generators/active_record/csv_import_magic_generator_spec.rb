require 'rails_helper'
require 'generators/active_record/csv_import_magic_generator'

RSpec.describe ActiveRecord::Generators::CsvImportMagicGenerator, type: :generator do
  destination File.expand_path("../../../../../tmp", __FILE__)
  arguments ['foo']

  before do
    prepare_destination

    FileUtils.mkdir_p('tmp/app/models')
    out_file = File.new(File.join(ENGINE_RAILS_ROOT, "tmp/app/models/foo.rb"), "w+")
    out_file.puts("class Foo\nend")
    out_file.close

    run_generator
  end

  after { prepare_destination }

  specify 'check structure of model' do
    expect(destination_root).to have_structure {
      directory "app" do
        directory "models" do
          file "foo.rb" do
            contains "csv_import_magic :foo"
          end
        end
      end
    }
  end

  specify 'check structure of parser' do
    parser_content = <<-EOF
class FooParser
  include ::CSVImporter

  model Foo

  # will update_or_create via :email
  # identifier :email

  # column :email, to: ->(email) { email.downcase }, required: true
  # column :first_name, as: [ /first.?name/i, /pr(é|e)nom/i ]
  # column :last_name,  as: [ /last.?name/i, "nom" ]
  # column :published,  to: ->(published, user) { user.published_at = published ? Time.now : nil }

  # or :abort
  #  when_invalid :skip
end
    EOF

    expect(destination_root).to have_structure {
      directory "app" do
        directory "csv_parsers" do
          file "foo_parser.rb" do
            contains parser_content
          end
        end
      end
    }
  end
end
