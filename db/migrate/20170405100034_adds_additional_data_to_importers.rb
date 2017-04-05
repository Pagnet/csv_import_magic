class AddsAdditionalDataToImporters < ActiveRecord::Migration
  def change
    add_column :importers, :additional_data, :json
  end
end
