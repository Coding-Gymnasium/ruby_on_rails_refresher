# frozen_string_literal: true

require "bigdecimal"
class BankAccount < ApplicationRecord
  def deposit(amount)
    amount_big = BigDecimal(amount)
    balance_big = BigDecimal(balance || 0)

    if amount_big <= 0
      raise ArgumentError, "Amount cannot be negative"
    end

    self.balance = balance_big + amount_big
  end

  def withdraw(amount)
    amount_big = BigDecimal(amount.to_s)
    balance_big = BigDecimal(balance || 0)

    if amount_big <= 0
      raise ArgumentError, "Amount cannot be negative"
    end
    raise Errors::InsufficientFunds, "Amount must not exceed balance" if amount_big > balance_big

    self.balance = balance_big - amount_big
  end

  private

  def balance=(amount)
    write_attribute(:balance, amount)
  end
end
