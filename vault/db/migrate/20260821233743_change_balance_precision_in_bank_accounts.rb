class ChangeBalancePrecisionInBankAccounts < ActiveRecord::Migration[8.1]
  def change
    change_column :bank_accounts, :balance, :decimal, precision: 10, scale: 2
  end
end
