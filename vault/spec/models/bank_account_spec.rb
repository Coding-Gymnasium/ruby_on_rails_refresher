# frozen_string_literal: true

require "rails_helper"

RSpec.describe BankAccount, type: :model do
  describe "Relations" do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
  end


  describe "Bank account activities" do
    before do
      @customer = Customer.create!(
        first_name: "Alice",
        last_name: "Smith",
        address: "123 Main St",
        email: "Alice@Example.com"
        )
      @account = BankAccount.create!(customer: @customer)
    end
    it "A Bank account starts with a nil balance" do
      expect(@account.balance).to be_nil
    end

    it 'Deposit increases the balance' do
      @account.deposit(100)
      expect(@account.balance).to eq(BigDecimal("100.00"))
    end

    it 'Withdrawal decreases the balance' do
      @account.deposit(100)
      @account.withdraw(30)
      expect(@account.balance).to eq(BigDecimal("70.00"))
    end

    it 'Negative deposit throws ArgumentError' do
      expect { @account.deposit(-5)  }.to raise_error(ArgumentError)
      expect { @account.deposit(0)  }.to raise_error(ArgumentError)
    end

    it "Withdrawing an amount greater than the balance throws InsufficientFunds error" do
      @account.deposit(20)
      expect { @account.withdraw(50)  }.to raise_error(Errors::InsufficientFunds)
    end
    it "Negative withdrawal throws ArgumentError" do
      expect { @account.withdraw(-5)  }.to raise_error(ArgumentError)
      expect { @account.withdraw(0)  }.to raise_error(ArgumentError)
    end
  end

  describe "Bank account transactions" do
    before do
      @customer = Customer.create!(
        first_name: "Alice",
        last_name: "Smith",
        address: "123 Main St",
        email: "Alice@Example.com"
  )
      @account = BankAccount.create!(customer: @customer)
    end

    it "has many transactions" do
      3.times do
        @account.transactions.create!(amount: 50, transaction_type: "deposit")
      end
      expect(@account.transactions.length).to eq(3)
    end

    it "recalculates balance after withdrawal" do
      @account.deposit(50)
      transaction = @account.transactions.create!(amount: 50, transaction_type: "deposit")
      orig_balance = @account.balance
      expect(orig_balance).to eq(BigDecimal("50.00"))
      @account.transactions.destroy(transaction)
      expect(@account.balance).to eq(BigDecimal("0.00"))
    end
  end
end
