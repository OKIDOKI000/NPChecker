class AddColumnImageName < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image_name, :string, :after => :encrypted_password, default: "", null: false
  end
end
