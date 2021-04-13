class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :title
      t.string :description
      t.boolean :secret
      t.integer :user_id
    end

    add_index :notes, :user_id
  end
end
