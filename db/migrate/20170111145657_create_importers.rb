class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.attachment :attachment
      t.attachment :attachment_error
      t.string :source
      t.string :columns
      t.string :error
      t.references :importable, polymorphic: true
      t.timestamps
    end
  end
end
