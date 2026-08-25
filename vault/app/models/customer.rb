class Customer < ApplicationRecord
  # Using composition instead of inheritance from a domain superclass like User.
  # Profile encapsulates identity behavior in one place, keeping Customer focused
  # on its own responsibilities and avoiding a fragile inheritance chain.
  def profile
    @profile ||=  Profile.new(
      first_name: first_name,
      last_name: last_name,
      address: address)
  end
end
