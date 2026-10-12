class AddEmailToCustomers < ActiveRecord::Migration[8.1]
  def change
    remove_index :customers, :email if index_exists?(:customers, :email)
    add_column :customers, :email, :citext
    add_column :customers, :phone, :string
    add_index :customers, :email, unique: true
  end
end
