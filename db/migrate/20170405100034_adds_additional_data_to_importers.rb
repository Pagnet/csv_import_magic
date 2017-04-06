class AddsAdditionalDataToImporters < ActiveRecord::Migration
  def change
    add_column :importers, :additional_data, :string
  end
end
