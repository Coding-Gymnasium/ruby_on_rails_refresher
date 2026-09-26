require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "relations" do
    it { should belong_to(:bank_account) }
  end
end
