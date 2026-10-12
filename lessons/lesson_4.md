# Lesson 4: Database Design and Migrations

## Explain

Your Rails app is only as strong as the database underneath it. Models, validations, and callbacks are conveniences — they're not the source of truth. The database is.

In this lesson you'll learn why **database-level constraints** matter, how to evolve your schema safely with **migrations**, and how to use **advanced column types** to make your schema both flexible and performant.

### Why DB constraints matter even when you have app validations

ActiveRecord validations are friendly — they collect errors and let you re-render forms. But they only run when you go through Ruby. Direct SQL, background jobs, other apps, or a bug in your code path all bypass them. A `NOT NULL` constraint, a `CHECK` constraint, or a foreign key enforced at the DB level cannot be bypassed.

The rule of thumb: **validate in the app for user experience; constrain in the database for data integrity.**

### Migration best practices

Migrations are version control for your schema. Treat them like code:

- **Reversibility** — every `change` should be reversible. Rails can auto-reverse simple `add_column`/`remove_column`, but for complex ops you need explicit `up`/`down`.
- **Safety** — avoid long-running `ALTER TABLE` on live databases. Use `disable_ddl_transaction!` when you need to run concurrent indexes (PostgreSQL allows this).
- **Idempotency** — migrations should be forward-only. Never modify a migration that's already been run in production.
- **Backfill carefully** — when adding a NOT NULL column to an existing table, backfill in a separate migration or use a default with a `DEFAULT` clause.

### Advanced column types

- **`citext`** — case-insensitive text. Perfect for emails. A `citext` column compares case-insensitively without needing `lower()` in queries. You must `enable_extension "citext"` first.
- **`enum`** — stores an integer but gives you named values. In Rails 7+, enums are defined in the model with `enum status: { draft: 0, published: 1 }`. The column type is integer. Avoid storing enums as strings — you lose the constraint and can get garbage data.
- **`jsonb`** — flexible, indexable JSON. Use it for data that doesn't fit neatly into columns (metadata, settings, audit logs). You can query and index inside it with GIN indexes.

### Seeding

`db/seeds.rb` should create the minimum data needed to run the app in every environment. Keep it idempotent using `find_or_create_by!`. For large datasets, split into `db/seeds/` files and load them in order.

## Setup

Run these commands from `vault/`:

```bash
# Add the citext extension
bin/rails g migration enable_citext_extension
# db/migrate/..._enable_citext_extension.rb
#   execute "CREATE EXTENSION IF NOT EXISTS citext;"

# Add email to customers
bin/rails g migration add_email_to_customers \
  email:citext:string \
  phone:string

# Add account type to bank accounts
bin/rails g migration add_account_type_to_bank_accounts \
  account_type:integer

# Add metadata to transactions
bin/rails g migration add_metadata_to_transactions \
  metadata:jsonb

# Add balance check constraint
bin/rails g migration add_balance_check_constraint

bin/rails db:migrate
```

## Practice

1. **Add `citext` email to `Customer`**
   - Generate a migration that adds an `email` column of type `citext` to `customers`
   - Enable the `citext` extension in a separate migration
   - Add a `validates :email, presence: true, uniqueness: { case_sensitive: false }` to the `Customer` model
   - Write a spec that confirms two customers with `Alice@Example.com` and `alice@example.com` cannot both be saved

2. **Add `account_type` enum to `BankAccount`**
   - Generate a migration adding an integer `account_type` column with a default of `0`
   - In `BankAccount`, define `enum account_type: { checking: 0, savings: 1, business: 2 }`
   - Write a spec that confirms `BankAccount.checking` returns a relation and that `account.checking?` returns true for a checking account

3. **Add `jsonb` metadata to `Transaction`**
   - Generate a migration adding a `metadata` `jsonb` column with a default of `{}` to `transactions`
   - In the `Transaction` model, add `serialize :metadata, Hash`
   - Write a spec that creates a transaction with `metadata: { "transfer_reference" => "TRX-123" }` and confirms it can be read back

4. **Add a `CHECK` constraint for `balance >= 0`**
   - Write a migration using raw SQL to add a check constraint to `bank_accounts`
   - Make it reversible (provide both `up` and `down` methods)
   - Write a spec that attempts to insert a bank account with a negative balance directly via SQL and confirms it raises `ActiveRecord::StatementInvalid`

5. **Seed data**
   - In `db/seeds.rb`, create 3 customers with emails
   - For each customer, create 1–2 bank accounts with different account types
   - For each account, create 2–3 transactions with varied `transaction_type` values and some metadata
   - Run `bin/rails db:seed` and confirm the counts in the console