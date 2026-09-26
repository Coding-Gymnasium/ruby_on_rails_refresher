# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer do
  describe "Relationships" do
    it { should have_many(:bank_accounts).dependent(:restrict_with_error) }
    it { should have_many(:transactions).through(:bank_accounts) }
  end

  describe "Customer" do
    before :each do
      @customer = Customer.create!
      @bank_account = BankAccount.create!(customer: @customer)
    end

    describe "Customer bank accounts" do
      it "has bank accounts" do
        expect(@customer.bank_accounts).to include(@bank_account)
        expect(@customer.bank_accounts[0]).to be_a(BankAccount)
      end

      it "prevents destruction when bank accounts exist" do
        expect { @customer.destroy }.not_to change(Customer, :count)
        expect(@customer.errors[:base]).to be_present
      end

      it "has many transactions through bank accounts" do
        3.times do
          @bank_account.transactions.create!(amount: 50, transaction_type: "deposit")
        end
        expect(@customer.transactions.length).to eq(3)
      end

      it "returns argument error when trying to assign an account to another customer" do
        customer_two = Customer.create!
        expect { customer_two.bank_accounts << @bank_account }.to raise_error ArgumentError
      end
    end
  end
end
