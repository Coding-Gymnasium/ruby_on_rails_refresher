class AddCustomerToBankAccounts < ActiveRecord::Migration[8.1]
  def change
    add_reference :bank_accounts, :customer, null: false, foreign_key: true
  end
end
