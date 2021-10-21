class AddColumnPriceToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :price, :integer, :after => :rank
  end
end
