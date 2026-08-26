# frozen_string_literal: true

require "rails_helper"

RSpec.describe BankAccount do
  describe "Bank account activities" do
    before do
      @account = BankAccount.create!
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
end
