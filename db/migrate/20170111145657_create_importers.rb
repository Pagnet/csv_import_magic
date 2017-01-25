class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.attachment :attachment
      t.attachment :attachment_error
      t.string :source
      t.string :parser
      t.string :columns
      t.string :message
      t.string :status, default: 'pending'
      t.references :importable, polymorphic: true
      t.timestamps
    end
  end
end
