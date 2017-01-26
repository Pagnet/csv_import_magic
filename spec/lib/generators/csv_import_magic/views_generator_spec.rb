require 'rails_helper'
require 'generators/csv_import_magic/views_generator'

RSpec.describe CsvImportMagic::Generators::ViewsGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __FILE__)
  arguments ['foo']

  before do
    prepare_destination
    run_generator
  end

  after { prepare_destination }

  specify 'check structure of show view' do
    show_content = <<-EOF
<h2 class='page-title'>
  <%= t('csv_import_magic.views.importers.show.title', model_translated: t("activemodel.models.#\{@importer.source\}.other")) %>
</h2>

<form style='text-align: center'>
  <div class='form-row' id="<%= @importer.status %>">
    <% if @importer.status == 'pending' %>
      <%= t('csv_import_magic.views.importers.show.waiting') %>
    <% else %>
      <%= @importer.message %>
    <% end %>
  </div>

  <% if @importer.status == 'pending' %>
    <span class='loading'></span>
  <% end %>

  <% if @importer.attachment_error.present? %>
    <%= link_to t('csv_import_magic.views.importers.show.buttons.error_file'), @importer.attachment_error.url, class: 'button button--secondary' %>
  <% end %>

  <%= link_to t('csv_import_magic.views.importers.show.buttons.back'), '/', class: 'button button--primary' %>
</form>

<script>
  if (document.getElementById('pending') != void 0) {
    setInterval(function(){
      location.reload();
    }, 5000);
  }
</script>
    EOF

    expect(destination_root).to have_structure {
      directory 'app' do
        directory 'views' do
          directory 'csv_import_magic' do
            directory 'importers' do
              file 'show.html.erb' do
                contains show_content
              end
            end
          end
        end
      end
    }
  end

  specify 'check structure of edit view' do
    edit_content = <<-EOF
<% columns = @importer.importable_columns(@importer.parser).map { |column| [@importer.source_klass.human_attribute_name(column), column] }.unshift([t('csv_import_magic.views.importers.edit.ignore_column_label'), :ignore]) %>

<h3 class='page-title'>
  <%= t('csv_import_magic.views.importers.edit.title') %>
  </br>
  <small><%= t('csv_import_magic.views.importers.edit.description') %></small>
</h3>

<%= simple_form_for @importer, url: importer_path(@importer) do |f| %>
  <div class="row csv_import">
    <% import_file_csv.headers.each_with_index do |header, i| %>
    <div class="column">
      <div class="portlet light bordered">
        <div class="portlet-body form">
          <header>
            <%= t('csv_import_magic.views.importers.edit.column') %> <b><%= header %></b>
          </header>

          <% selected = columns.find { |c| c.join(' ').match(/#\{header\}/i) }.try(:last).presence || :ignore %>
          <%= f.input "columns][", as: :select, collection: columns, label: false, hint: t('csv_import_magic.views.importers.edit.hint'), include_blank: false, selected: f.object.columns[i] || selected %>

          <header class="examples"><%= t('csv_import_magic.views.importers.edit.example_of_values') %></header>
          <table>
            <tbody>
              <% import_file_csv.first(5).each_with_index do |row, c| %>
                <tr>
                  <td class="number"><%= c + 1 %></td>
                  <td><%= row[header] || t('csv_import_magic.views.importers.edit.empty_values') %></td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    <% end %>
  </div>
    EOF

    expect(destination_root).to have_structure {
      directory 'app' do
        directory 'views' do
          directory 'csv_import_magic' do
            directory 'importers' do
              file 'edit.html.erb' do
                contains edit_content
              end
            end
          end
        end
      end
    }
  end

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

  <body class="csv_import_magic">
    <%- if flash %>
      <% flash.each do |key, value| %>
        <div class="flash-message <%= key %>"><%= value %></div>
      <% end %>
    <% end %>

    <div class="wrapper">
      <main>
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
      directory 'app' do
        directory 'views' do
          directory 'layouts' do
            file 'csv_import_magic.html.erb' do
              contains layout_content
            end
          end
        end
      end
    }
  end

  specify 'check structure of partial view' do
    partial_view_content = <<-EOF
<h1 class="page-title">
  <%= t('csv_import_magic.views.importers.new.title', model_translated: t('activemodel.models.foo.other')) %>
  <br/>
  <small><%= t('csv_import_magic.views.importers.new.description', model_translated: t('activemodel.models.foo.other').downcase) %></small>
</h1>

<%= simple_form_for(Importer.new, url: csv_import_magic.importers_path) do |f| %>
  <%= f.input :importable_type, as: :hidden, input_html: { value: '<change this value>' } %>
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
      directory 'app' do
        directory 'views' do
          directory 'foos' do
            file '_csv_importer.html.erb' do
              contains partial_view_content
            end
          end
        end
      end
    }
  end
end
