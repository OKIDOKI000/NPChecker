class AddAndDeleteColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :name, :string, null: false
    add_column :products, :entry_time, :datetime, null: false
    add_column :products, :rank, :integer
    add_column :products, :link, :string
    remove_column :products, :content, :text
    add_index :products, :name, unique: true
    add_index :products, :entry_time, unique: true
  end
end
