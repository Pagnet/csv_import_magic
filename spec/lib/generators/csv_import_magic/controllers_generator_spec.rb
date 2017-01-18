require 'rails_helper'
require 'generators/csv_import_magic/controllers_generator'

RSpec.describe CsvImportMagic::Generators::ControllersGenerator, type: :generator do
  destination File.expand_path("../../../../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator
  end

  after { prepare_destination }

  specify 'check structure of base_controller' do
    base_controller_content = <<-EOF
class CsvImportMagic::BaseController < ActionController::Base
end
    EOF

    expect(destination_root).to have_structure {
      directory "app" do
        directory "controllers" do
          directory "csv_import_magic" do
            file "base_controller.rb" do
              contains base_controller_content
            end
          end
        end
      end
    }
  end
end
