require 'rails/generators/base'

module CsvImportMagic
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a CSV Import Magic initializer to your application."

      def copy_initializer
        template 'csv_import_magic.rb', 'config/initializers/csv_import_magic.rb'
      end

      desc "Creates a routes to your application."

      class_option :routes, desc: "Generate routes", type: :boolean, default: true

      def add_csv_import_magic_routes
        route "mount CsvImportMagic::Engine => '/csv_import_magic'"
      end

      def add_importer_migration
        migration_template 'migration.rb', "db/migrate/create_#{table_name}.rb"
      end

      def self.next_migration_number(dir)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def table_name
        'importers'
      end

      def migration_data
<<RUBY
      t.attachment :attachment
      t.attachment :attachment_error
      t.string :source
      t.string :columns
      t.string :error
      t.references :importable, polymorphic: true
RUBY
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def migration_version
        if rails5?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  end
end