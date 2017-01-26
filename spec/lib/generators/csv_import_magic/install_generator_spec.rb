require 'rails_helper'
require 'generators/csv_import_magic/install_generator'

RSpec.describe CsvImportMagic::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __FILE__)

  before do
    travel_to Time.zone.parse('20170101235959')
    prepare_destination

    FileUtils.mkdir_p('tmp/config')

    out_file = File.new(File.join(ENGINE_RAILS_ROOT, 'tmp/config/routes.rb'), 'w+')
    out_file.puts("Rails.application.routes.draw do\nend")
    out_file.close

    run_generator
  end

  after do
    prepare_destination
    travel_back
  end

  specify 'check structure of routes' do
    expect(destination_root).to have_structure {
      directory 'config' do
        file 'routes.rb' do
          contains "mount CsvImportMagic::Engine => '/csv_import_magic'"
        end
      end
    }
  end

  specify 'check structure of migrateion' do
    migration_content = <<-EOF
class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.attachment :attachment
      t.attachment :attachment_error
      t.string :source
      t.string :parser
      t.string :columns
      t.string :message
      t.string :status, default: 'pending'
      t.references :importable, polymorphic: true
      t.timestamps null: false
    end

    add_index :importers, [:importable_id, :importable_type]
  end
end
    EOF

    expect(destination_root).to have_structure {
      directory 'db' do
        directory 'migrate' do
          file '20170101235959_create_importers.rb'
          migration 'create_importers' do
            contains migration_content
          end
        end
      end
    }
  end

  specify 'check structure of locale' do
    expect(destination_root).to have_structure {
      directory 'config' do
        directory 'locales' do
          file 'csv_import_magic.en.yml' do
            contains 'en:'
          end
        end
      end
    }
  end
end
