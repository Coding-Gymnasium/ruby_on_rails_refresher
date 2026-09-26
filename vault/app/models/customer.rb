class Customer < ApplicationRecord
  has_many :bank_accounts,
    dependent: :restrict_with_error,
    before_add: :prevent_duplicate_bank_account
  has_many :transactions, through: :bank_accounts

  # Using composition instead of inheritance from a domain superclass like User.
  # Profile encapsulates identity behavior in one place, keeping Customer focused
  # on its own responsibilities and avoiding a fragile inheritance chain.
  def profile
    @profile ||=  Profile.new(
      first_name: first_name,
      last_name: last_name,
      address: address)
  end

  private
  def prevent_duplicate_bank_account(bank_account)
    raise ArgumentError, "Bank account already belongs to another customer" if bank_account.customer_id.present?
  end
end
