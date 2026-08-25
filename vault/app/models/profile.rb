class Profile
  attr_reader :first_name, :last_name, :address
  def initialize(first_name:, last_name:, address:)
    @first_name = first_name
    @last_name = last_name
    @address = address
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
