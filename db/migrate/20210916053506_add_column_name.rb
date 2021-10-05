class AddColumnName < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, :before => :email
  end
end
