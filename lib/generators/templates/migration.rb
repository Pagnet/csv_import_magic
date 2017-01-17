class Create<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %> do |t|
<%= migration_data -%>
      t.timestamps null: false
    end

    add_index :<%= table_name %>, [:importable_id, :importable_type]
  end
end
