class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.references :user
      t.string :name
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country
      t.boolean :active
    end
  end
end
