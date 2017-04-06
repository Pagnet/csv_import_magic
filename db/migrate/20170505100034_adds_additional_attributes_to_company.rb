class AddsAdditionalAttributesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :one_additional_attribute, :string
    add_column :companies, :other_additional_attribute, :string
  end
end
