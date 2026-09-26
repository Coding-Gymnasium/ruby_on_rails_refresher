# Lesson 3: ActiveRecord Associations

## Concept 3.1: Wiring Models Together

### Explain

ActiveRecord associations are how Rails expresses relationships between tables. Instead of writing raw SQL joins every time you need related records, you declare the relationship in your model and Rails builds the queries for you.

The three association types you'll use most often are:

- **`belongs_to`** — the child side. A `BankAccount` belongs to a `Customer`. The foreign key (`customer_id`) lives on the `bank_accounts` table.
- **`has_many`** — the parent side. A `Customer` has many `BankAccount` records.
- **`has_many :through`** — a many-to-many relationship with a join model. `Customer has_many :transactions, through: :bank_accounts` lets you ask a customer for all transactions across all their accounts without manually joining tables.

Associations also give you helper methods: `customer.bank_accounts` returns a collection, `bank_account.customer` returns the parent, and `customer.bank_accounts << new_account` builds the relationship. These helpers obey your validations and callbacks, so you get safe object construction for free.

Association callbacks (`before_add`, `after_remove`) let you react to changes in the relationship — for example, logging when a bank account is removed from a customer.

---

### Setup

**Step 1: Add `customer_id` to `bank_accounts`**

Generate a migration to add the foreign key:

```bash
bin/rails generate migration AddCustomerToBankAccounts customer:references
```

This creates a migration that adds `customer_id` to `bank_accounts` and an index. Run it:

```bash
bin/rails db:migrate
```

**Step 2: Create the `Transaction` model**

Generate the model and migration:

```bash
bin/rails generate model Transaction bank_account:references amount:decimal transaction_type:string
bin/rails db:migrate
```

This creates a `transactions` table with a foreign key to `bank_accounts`, a decimal `amount` column, and a string `transaction_type` column (e.g., `"deposit"`, `"withdrawal"`).

Then open the generated migration and add `precision: 10, scale: 2` to the `amount` column, or modify it to:

```ruby
t.decimal :amount, precision: 10, scale: 2
```

Then run `bin/rails db:migrate` again.

**Step 3: Verify the schema**

Inspect `db/schema.rb` to confirm:

- `bank_accounts` has a `customer_id` column
- `transactions` has a `bank_account_id` column

---

### Practice

**Task 1: Wire up `Customer` and `BankAccount`**

Goal: Declare the associations between `Customer` and `BankAccount`, then verify them in specs.

Requirements:
- A `Customer` has many `bank_accounts`
- A `BankAccount` belongs to a `customer`
- `bank_account.customer` returns the owning customer
- `customer.bank_accounts` returns all accounts for that customer
- Creating a `BankAccount` without a `customer` raises a validation error
- A customer cannot be destroyed if they have bank accounts (use `dependent: :restrict_with_error`)

Hints:
- Add `belongs_to :customer` inside `BankAccount`. Rails will automatically validate presence of the foreign key if you pass `optional: false` (or omit `optional` entirely, since Rails 5+ defaults to required).
- Add `has_many :bank_accounts, dependent: :restrict_with_error` inside `Customer`.
- In specs, use `create(:customer)` and `create(:bank_account, customer: customer)` if you add FactoryBot, or use `Customer.create!` / `BankAccount.create!` directly.
- Test the restriction with `expect { customer.destroy }.to change(Customer, :count).by(0)` and check that `customer.errors[:base]` contains a message.

Write specs in `spec/models/customer_spec.rb` and `spec/models/bank_account_spec.rb`.

---

**Task 2: Build a `has_many :through` for transactions**

Goal: Let a customer access all their transactions across every account via a single association.

Requirements:
- `BankAccount has_many :transactions`
- `Transaction belongs_to :bank_account`
- `Customer has_many :transactions, through: :bank_accounts`
- `customer.transactions` returns every transaction for every account owned by the customer
- Creating a transaction through the association automatically sets the `bank_account_id`

Hints:
- Start inside `BankAccount`: declare `has_many :transactions`.
- Then inside `Customer`: declare `has_many :transactions, through: :bank_accounts`.
- Test that `customer.transactions` includes transactions from multiple accounts: create two accounts, add transactions to each, then verify the customer sees both.
- Test the through-association writer: `customer.transactions << Transaction.new(...)` should set the `bank_account_id` automatically on the first account.

Write specs in `spec/models/customer_spec.rb` or `spec/models/transaction_spec.rb`.

---

**Task 3: Add association callbacks**

Goal: React to association changes using callbacks.

Requirements:
- A bank account cannot be added to a customer if it already belongs to another customer
- When a transaction is removed from a bank account, the account balance is recalculated

Hints:
- Use `before_add` on `has_many :bank_accounts` inside `Customer`. In the callback method, check whether the bank account already has a `customer_id` set. If it does, raise an error to block the association from being added.
- Use `after_remove` on `has_many :transactions` inside `BankAccount`.
- Callbacks receive the added/removed object as an argument, so you can call methods on it.
- For the `before_add` spec: create two customers, create a bank account for the first customer, then try adding that same account to the second customer through the association proxy. Expect an `ArgumentError`.
- For the `after_remove` spec: create a bank account with a transaction, record the balance, remove the transaction, and expect the balance to decrease by the transaction amount.

Write specs that verify the callbacks fire by checking side effects (e.g., an error is raised, or the balance changes).

---

*Complete each task and reply for review.*
