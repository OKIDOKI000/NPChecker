class ChangeImageNameDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :image_name, :string, default: "default_image.jpg"
  end
end
