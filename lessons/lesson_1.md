# Lesson 1: Advanced Ruby OOP & Domain Modeling in Rails

## Concept 1.1: Encapsulation, Polymorphism, Inheritance vs. Composition

### Explain

**Encapsulation** bundles state and behavior together while hiding implementation details. In Rails models, this means keeping sensitive attributes private and exposing only intentional interfaces (e.g., `deposit`/`withdraw` instead of direct balance assignment).

**Polymorphism** lets different objects respond to the same message in domain-specific ways. Ruby achieves this through duck typing, inheritance, and modules. Rails uses it everywhere—ActiveRecord associations, serializers, and policy objects.

**Inheritance vs. Composition**: Inheritance models an "is-a" relationship (`AdminUser < User`). Composition models a "has-a" relationship by delegating to contained objects. Rails generally prefers composition because deep inheritance hierarchies become fragile and hard to test.

---

### Setup

Run these commands in your Rails app to set up the domain:

**Step 1: Configure the database**
```bash
bin/rails db:create
```
This creates `vault_development` and `vault_test` databases defined in `config/database.yml`.

**Step 2: Generate the BankAccount model**
```bash
bin/rails g model BankAccount balance:decimal
bin/rails db:migrate
```

**Step 3: Adjust precision on the balance column**
```bash
bin/rails g migration ChangeBalancePrecisionInBankAccounts
```

Edit the new migration to change the column:
```ruby
class ChangeBalancePrecisionInBankAccounts < ActiveRecord::Migration[8.1]
  def change
    change_column :bank_accounts, :balance, :decimal, precision: 10, scale: 2
  end
end
```

Then run:
```bash
bin/rails db:migrate
```

Verify in the database console:
```bash
bin/rails dbconsole
```
```sql
\d bank_accounts
```
You should see `balance` as `numeric(10,2)`. Exit with `\q`.

---

### Practice

**Task 1: Encapsulation**

Goal: Make `BankAccount` enforce that `balance` can only change through `deposit` and `withdraw`.

Requirements:
- `deposit(amount)` — adds a positive amount to the balance
- `withdraw(amount)` — subtracts a positive amount if funds are available
- Both methods must raise `ArgumentError` for invalid input (zero or negative amounts)
- `withdraw` must raise `InsufficientFunds` if the amount exceeds the balance
- `balance` must not be writable from outside the class

Hints:
- You'll need a custom error class. Create `app/models/errors/insufficient_funds.rb`:
  ```ruby
  class InsufficientFunds < StandardError; end
  ```
- Use `private` to hide the `balance=` writer method.
- Use `BigDecimal` for precise decimal arithmetic. Convert with `BigDecimal(amount)` and `BigDecimal(balance || 0)`.
- New accounts have `nil` balance, so handle that with `|| 0`.

Implement this in `app/models/bank_account.rb`.

---

**Task 2: Polymorphism**

Goal: Create a `Notifiable` module that multiple models can include, each responding to `notify(message)` in its own way.

Requirements:
- Create `app/models/concerns/notifiable.rb`
- Use `ActiveSupport::Concern` to define the module
- Include a default `notify(message)` that raises `NotImplementedError`
- Include the module in two models (e.g., `Article` and `Video`) and override `notify` in each so they behave differently

Hints:
- `ActiveSupport::Concern` gives you an `included` block for setting up associations when the module is included
- The whole point is that both models respond to the same method (`notify`) but produce different behavior — that's polymorphism

---

**Task 3: Composition over Inheritance**

Goal: Replace an inheritance relationship with a value object.

Imagine this problematic inheritance setup:
```ruby
class Customer < User
end
```
`Customer` inherits everything from `User` even though it only needs name and address fields. This is fragile: changes to `User` break `Customer`, and testing becomes complicated.

Refactor it to use composition instead.

Requirements:
- Create `app/models/profile.rb` as a plain Ruby value object with `first_name`, `last_name`, and `address`
- Create or update `app/models/customer.rb` to use `Profile` instead of inheriting from `User`
- `Customer#profile` should build a `Profile` from its own attributes and memoize it with `@profile ||=`

Hints:
- `Profile` does not inherit from `ApplicationRecord` — it's just a plain Ruby class
- Use `attr_reader` for read-only attributes
- Memoization (`@profile ||=`) ensures the object is only built once per instance

Add a comment in `customer.rb` explaining why composition is preferable here.

---

*Complete each task and reply for review.*
