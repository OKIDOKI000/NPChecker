class RemoveEntryTimeUnique < ActiveRecord::Migration[5.2]
  def change
    remove_index :products, :entry_time
  end
end
