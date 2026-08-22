# Lesson 1: Advanced Ruby OOP & Domain Modeling in Rails

## Concept 1.1: Encapsulation, Polymorphism, Inheritance vs. Composition

### Explain

**Encapsulation** bundles state and behavior together while hiding implementation details. In Rails models, this means keeping sensitive attributes private and exposing only intentional interfaces (e.g., `deposit`/`withdraw` instead of direct balance assignment).

**Polymorphism** lets different objects respond to the same message in domain-specific ways. Ruby achieves this through duck typing, inheritance, and modules. Rails uses it everywhere—ActiveRecord associations, serializers, and policy objects.

**Inheritance vs. Composition**: Inheritance models an "is-a" relationship (`AdminUser < User`). Composition models a "has-a" relationship by delegating to contained objects. Rails generally prefers composition because deep inheritance hierarchies become fragile and hard to test.

### Demonstrate

Run these steps in your Rails app:

**Step 1: Generate a Rails model**
```bash
bin/rails g model BankAccount balance:decimal
```

What just happened?
- `bin/rails` runs the Rails executable bundled with your project (via Bundler), ensuring the correct gem versions are loaded.
- `g` is shorthand for `generate`.
- `model BankAccount` tells Rails to create a model named `BankAccount`.
- `balance:decimal` creates a migration with a `balance` column of type `decimal`.

Rails created:
- `app/models/bank_account.rb` — the model class
- `db/migrate/XXXXXXXXXX_create_bank_accounts.rb` — the migration file

The generator defaults `decimal` to `precision: 10, scale: 2`, meaning 10 total digits with 2 after the decimal point. If you need different values, you edit the migration manually before running it.

**Step 2: Apply the migration**
```bash
bin/rails db:migrate
```

What just happened?
- Rails reads pending migration files in `db/migrate/` and runs them against your database.
- Each migration has a timestamp in its filename. Rails tracks which migrations have already run in a table called `schema_migrations`.
- `db:migrate` creates or alters tables in `vault_development` (your local database).

**Step 3: Verify the column**
```bash
bin/rails dbconsole
```
Inside PostgreSQL, run:
```sql
\d bank_accounts
```
You should see a `balance` column of type `numeric(10,2)`. Exit with `\q`.

**Step 4: Edit the model to enforce encapsulation**
Edit `app/models/bank_account.rb`:
```ruby
class BankAccount < ApplicationRecord
  def deposit(amount)
    raise ArgumentError, "Amount must be positive" if amount <= 0
    self.balance = (balance || 0) + amount
  end

  def withdraw(amount)
    raise ArgumentError, "Amount must be positive" if amount <= 0
    raise InsufficientFunds, "Balance too low" if amount > balance.to_d
    self.balance = balance - amount
  end
end
```

What just happened?
- We removed the ability to set `balance` directly from outside the class.
- `deposit` and `withdraw` are the only public interfaces for changing the balance.
- `ArgumentError` guards against invalid input (negative amounts).
- `InsufficientFunds` is a custom error class we'll define next.
- `to_d` converts the decimal to a `BigDecimal` for precise comparison.

Create `app/models/errors/insufficient_funds.rb`:
```ruby
class InsufficientFunds < StandardError; end
```

**Step 5: Create a `Notifiable` module showing polymorphism**
```ruby
# app/models/concerns/notifiable.rb
module Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :notifiable
  end

  def notify(message)
    raise NotImplementedError, "Each model must implement #notify"
  end
end
```

What just happened?
- `ActiveSupport::Concern` is a Rails helper for clean mixin modules.
- The `included` block runs when the module is included in a class, setting up the `has_many` association.
- `notify` raises `NotImplementedError` by default. Each including class must override it.

Include it in models:
```ruby
# app/models/article.rb
class Article < ApplicationRecord
  include Notifiable

  def notify(message)
    Notification.create!(notifiable: self, message: "Article update: #{message}")
  end
end

# app/models/video.rb
class Video < ApplicationRecord
  include Notifiable

  def notify(message)
    Notification.create!(notifiable: self, message: "Video alert: #{message}")
  end
end
```

What just happened?
- Both `Article` and `Video` respond to `notify`, but each formats the message differently.
- This is polymorphism: same interface (`notify`), different behavior.

**Step 6: Illustrate composition over inheritance with a `Profile` value object**
```ruby
# app/models/profile.rb
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
```

```ruby
# app/models/customer.rb
class Customer < ApplicationRecord
  def profile
    @profile ||= Profile.new(
      first_name: first_name,
      last_name: last_name,
      address: address
    )
  end
end
```

What just happened?
- `Profile` is a value object: it represents a concept (`first_name`, `last_name`, `address`) without its own database table.
- `Customer` "has a" `Profile` instead of inheriting from a `User` class.
- `@profile ||= ...` memoizes the object so it's only built once per instance.
- This is composition: we delegate the name logic to `Profile` rather than stuffing it into `Customer` or building a deep inheritance chain.

### Practice

1. **Encapsulation**: In `BankAccount`, ensure `balance` cannot be modified directly—only via `deposit(amount)` and `withdraw(amount)`. Raise an error on invalid operations.
2. **Polymorphism**: Create a `Renderable` module with a `render` method. Include it in `Article` and `Video` so both respond to `render` but return different output (HTML vs. embed code).
3. **Composition vs. Inheritance**: Refactor a `Customer` model that currently inherits from `User` into a composition pattern using a `Profile` value object. Add a comment explaining why this is preferable for your domain.

---
*Progress through these tasks and reply when complete for review.*
