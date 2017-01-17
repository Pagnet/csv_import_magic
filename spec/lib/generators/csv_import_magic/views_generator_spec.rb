require 'rails_helper'
require 'generators/csv_import_magic/views_generator'

RSpec.describe CsvImportMagic::Generators::ViewsGenerator, type: :generator do
  destination File.expand_path("../../../../../tmp", __FILE__)
  arguments ['foo', '-i', 'bar']

  before do
    prepare_destination
    run_generator
  end

  after { prepare_destination }

  specify 'check structure of view' do
    view_content = <<-EOF
<%= simple_form_for(Importer.new, url: csv_import_magic.importers_path) do |f| %>
  <%= f.input :importable_type, as: :hidden, input_html: { value: 'Bar' } %>
  <%= f.input :importable_id, as: :hidden, input_html: { value: '<change this value>' } %>
  <%= f.input :source, as: :hidden, input_html: { value: 'foo' } %>

  <div>
    <h4 class="modal-title">Importação</h4>
  </div>

  <div>
    <p><strong>Importação</strong>:</p>
    <%= f.input :attachment, as: :file, label: false, required: true %>
    <p>Envie um arquivo <b>CSV</b> com títulos/headers.</p>
  </div>

  <div>
    <%= f.submit 'Importar', class: 'btn green' %>
  </div>
<% end %>
    EOF

    expect(destination_root).to have_structure {
      directory "app" do
        directory "views" do
          directory "foos" do
            file "_csv_importer.html.erb" do
              contains view_content
            end
          end
        end
      end
    }
  end
end
