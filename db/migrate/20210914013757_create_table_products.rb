class CreateTableProducts < ActiveRecord::Migration[5.2]
  def change
    create_table "products" do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "name", null: false
      t.datetime "entry_time", null: false
      t.integer "rank"
      t.string "link"
      t.integer "price"
      t.index ["name"], name: "index_products_on_name", unique: true
    end
  end
end
