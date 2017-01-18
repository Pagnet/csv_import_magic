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

  specify 'check structure of layout view' do
    layout_content = <<-EOF
<!DOCTYPE html>
<html lang="pt">
  <head>
    <meta charset="utf-8">
    <title>Title</title>

    <link href="/favicon.ico" rel="shortcut icon">

    <%= stylesheet_link_tag "application", :media => "all" %>
    <%= csrf_meta_tags %>
  </head>

  <body class="<%= body_class %> csv_import_magic">
    <%- if flash %>
      <% flash.each do |key, value| %>
        <div class="flash-message <%= key %>"><%= value %></div>
      <% end %>
    <% end %>

    <div class="wrapper">
      <main class="<%= yield(:main_class) %>">
        <div class="container">
          <%= yield %>
        </div>
      </main>
    </div>

    <%= javascript_include_tag "application" %>
    <%= yield :javascript %>
  </body>
</html>
    EOF

    expect(destination_root).to have_structure {
      directory "app" do
        directory "views" do
          directory "layouts" do
            file "csv_import_magic.html.erb" do
              contains layout_content
            end
          end
        end
      end
    }
  end

  specify 'check structure of partial view' do
    partial_view_content = <<-EOF
<h1 class="page-title"><%= t('csv_import_magic.views.importers.new.title', model_translated: t('activemodel.models.foo.other')) %></h1>

<h2>
  <%= t('csv_import_magic.views.importers.new.description', model_translated: t('activemodel.models.foo.other').downcase) %>
</h2>

<%= simple_form_for(Importer.new, url: csv_import_magic.importers_path) do |f| %>
  <%= f.input :importable_type, as: :hidden, input_html: { value: 'Bar' } %>
  <%= f.input :importable_id, as: :hidden, input_html: { value: '<change this value>' } %>
  <%= f.input :source, as: :hidden, input_html: { value: 'foo' } %>

  <div class="form-row">
    <%= f.input :attachment, as: :file, hint: t('csv_import_magic.views.importers.new.hint').html_safe, required: true %>
  </div>

  <div class='form-row actions'>
    <%= f.submit t('csv_import_magic.views.importers.new.buttons.import'), class: 'button button--primary' %>
  </div>
<% end %>
    EOF

    expect(destination_root).to have_structure {
      directory "app" do
        directory "views" do
          directory "foos" do
            file "_csv_importer.html.erb" do
              contains partial_view_content
            end
          end
        end
      end
    }
  end
end
