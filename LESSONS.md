# Vault Learning Plan

A progressive Rails curriculum for mid-to-senior developers. Each lesson builds on the previous one using the Vault banking domain.

---

## Lesson 1: Advanced Ruby OOP & Domain Modeling
**Status: Complete**

- Encapsulation, polymorphism, inheritance vs. composition
- Value objects and the `BankAccount` model
- Polymorphic modules with `ActiveSupport::Concern`
- Composition over inheritance with `Profile`

---

## Lesson 2: RSpec and Testing Models
**Focus: Test-driven confidence in existing code**

- Add RSpec to the project (replace or augment Minitest)
- Configure `spec/` directory, `.rspec`, and `rails_helper.rb`
- Test `BankAccount` — deposit, withdraw, edge cases
- Test `Profile` value object behavior
- Test polymorphic `Notifiable` behavior
- Learn RSpec matchers, `let`, `before`, and shared examples

---

## Lesson 3: ActiveRecord Associations
**Focus: Wiring models together**

- `Customer has_many :bank_accounts`
- `BankAccount belongs_to :customer`
- `Transaction` model as a join/through record
- `has_many :through` for richer queries
- Association callbacks and validation

---

## Lesson 4: Database Design and Migrations
**Focus: Schema evolution in production**

- Migration best practices (reversibility, safety)
- Adding indexes and foreign keys
- Database constraints vs. application validations
- Advanced column types (`jsonb`, `enum`, `citext`)
- Seeding data with `db/seeds.rb` and `db/seeds/`

---

## Lesson 5: Advanced ActiveRecord and Query Optimization
**Focus: Writing efficient database queries**

- Scopes and class methods
- Eager loading (`includes`, `preload`, `eager_load`)
- N+1 query detection and prevention
- `select`, `pluck`, and `find_by` vs. `where`
- Database views and read models
- Counter caches

---

## Lesson 6: Service Objects and Refactoring Patterns
**Focus: Keeping models and controllers thin**

- Service objects for business logic (`TransferFunds`, `CloseAccount`)
- Form objects for complex input (`AccountOpeningForm`)
- Query objects for reusable searches
- Decorators/presenters for view logic
- Interactors and the command pattern

---

## Lesson 7: Authentication and Authorization
**Focus: Securing the application**

- Authentication with `has_secure_password` and bcrypt
- Session management and password reset flows
- Authorization with Pundit (policies and scopes)
- Role-based access control
- OWASP Top 10 in Rails context

---

## Lesson 8: Security Deep Dive
**Focus: Common Rails vulnerabilities and defenses**

- Mass assignment and strong parameters
- SQL injection and safe query construction
- XSS, CSRF, and session fixation
- Rate limiting with `rack-attack`
- Secure headers and CORS configuration

---

## Lesson 9: Testing Controllers and Requests
**Focus: Integration and request specs**

- Request specs with RSpec
- Testing authentication and authorization flows
- Testing JSON and HTML responses
- Shared examples for common patterns
- Test factories with FactoryBot

---

## Lesson 10: Background Jobs and Asynchronous Processing
**Focus: Moving work off the request thread**

- ActiveJob with Solid Queue (Rails 8 default)
- Writing and enqueueing jobs (`GenerateStatement`, `SendReceipt`)
- Error handling and retry strategies
- Testing jobs in isolation
- When NOT to use background jobs

---

## Lesson 11: Mailers and Notifications
**Focus: Sending email reliably**

- `ActionMailer` setup and previews
- Transactional email patterns (`WelcomeMailer`, `StatementMailer`)
- Multipart emails (HTML + plain text)
- Background delivery with ActiveJob
- Email testing with `mailcatcher` or `letter_opener`

---

## Lesson 12: File Uploads and ActiveStorage
**Focus: Handling user-uploaded files**

- Attaching files to models
- Direct uploads with JavaScript
- Image processing with `image_processing` gem
- Service variants (thumbnails, previews)
- Storage backends (local, S3, etc.)

---

## Lesson 13: Caching and Performance
**Focus: Making the app faster**

- Fragment caching in views
- Russian doll caching
- Low-level caching with `Rails.cache`
- Cache stores (memory, Redis, Memcached)
- Cache keys and expiration strategies
- HTTP caching and ETags

---

## Lesson 14: API Design and Serialization
**Focus: Building a JSON API**

- Namespaced routes (`namespace :api`)
- JSON serialization with `jsonapi-serializer`
- Versioning strategies (`/api/v1/...`)
- Error handling and consistent response format
- Documenting with OpenAPI/Swagger

---

## Lesson 15: Hotwire, Stimulus, and Modern Frontend
**Focus: Rails-native interactivity**

- Turbo Drive and Turbo Frames
- Turbo Streams for real-time updates
- Stimulus controllers for JavaScript behavior
- Building a live account balance update without writing custom JS

---

## Lesson 16: Containerization and Deployment
**Focus: Shipping to production**

- Dockerfile for Rails with PostgreSQL
- Docker Compose for local development
- Kamal deployment (Rails 8 default)
- Environment variables and secrets management
- Health checks and zero-downtime deploys

---

## Lesson 17: Monitoring, Logging, and Observability
**Focus: Understanding production behavior**

- Structured logging with `lograge`
- Error tracking with Sentry
- Performance monitoring
- Database query analysis
- Health checks and uptime monitoring

---

## Lesson 18: Advanced Topics and Best Practices
**Focus: Senior-level concerns**

- Database transactions and isolation levels
- Concurrency and race conditions
- Internationalization (i18n) with `gettext` or Rails i18n
- Code quality: RuboCop, test coverage, code review practices
- Refactoring legacy Rails codebases
- Planning for scale

---

## Guiding Principles

- All lessons tie back to the Vault banking domain
- Each lesson has hands-on code, not just theory
- We favor understanding *why* over memorizing *how*
- Production-readiness is considered from day one

---

# Stage 2: Production Rails — Sidekiq, Redis, and the Brite Cleaning App

**Project:** Brite — a cleaning company management tool.  
**Stack:** Rails + PostgreSQL + Sidekiq + Redis + Sentry/CloudWatch  
**Focus:** Realistic production patterns you'll encounter in existing codebases.

## Why a second project?

Stage 1 uses Rails 8 native tooling (Solid Queue, Solid Cache). Stage 2 intentionally uses the **traditional production stack** still dominant in most companies: Sidekiq, Redis, and third-party observability. The domain changes too, so you can't rely on muscle memory — you have to actually apply the patterns.

## Domain Overview

- **Customer** — requests cleaning services
- **Quote** — estimated price and scope for a job
- **Team** — a group of cleaners
- **Employee** — a person who belongs to a team
- **Job** — a scheduled cleaning assignment
- **Scheduling** — recurring or one-off job assignments with time slots
- **Inventory** — cleaning supplies, consumables, equipment

---

## Lesson 19: Stage 2 Setup and RSpec Revisited
**Focus: New project, new stack**

- Generate the Brite app with PostgreSQL
- Add RSpec and configure the test suite
- Set up Sidekiq and Redis for development
- Configure Sentry for error tracking
- Compare the setup experience with Stage 1

---

## Lesson 20: Domain Modeling and Associations
**Focus: Cleaning company relationships**

- `Customer has_many :quotes`
- `Quote belongs_to :customer`
- `Team has_many :employees`
- `Job belongs_to :team` and `belongs_to :quote`
- `Employee has_many :jobs, through: :team`
- `InventoryItem belongs_to :job` (optional: supplies needed for a job)
- Polymorphic `Notifiable` reimagined for the new domain

---

## Lesson 21: Database Design for Real-World Workflows
**Focus: Scheduling and inventory**

- `enum` for job status (`scheduled`, `in_progress`, `completed`, `cancelled`)
- `jsonb` for flexible job metadata (room counts, special instructions)
- `citext` for case-insensitive customer emails
- Composite uniqueness validations
- Foreign keys and database constraints
- Seed data with realistic cleaning business scenarios

---

## Lesson 22: Advanced ActiveRecord in a Complex Domain
**Focus: Querying across teams, schedules, and inventory**

- Scopes for active jobs, available teams, low-stock inventory
- N+1 prevention in team/job dashboards
- Eager loading for customer quote history
- Counter caches for team job counts
- Database views for daily revenue reporting

---

## Lesson 23: Service Objects and State Machines
**Focus: Business logic for job lifecycles**

- Service objects: `AssignTeamToJob`, `GenerateQuote`, `CompleteJob`
- State machine for job status transitions
- Form objects for quote creation with nested validation
- Decorators for job pricing display
- When to reach for a service object vs. a model method

---

## Lesson 24: Authentication and Authorization
**Focus: Multi-role access**

- `has_secure_password` for employees
- Role-based access: admin, team_lead, cleaner, customer
- Pundit policies: who can assign teams, view quotes, modify jobs?
- Customer self-service portal
- API tokens for mobile or integrations

---

## Lesson 25: Security and Input Validation
**Focus: Hardening a business app**

- Strong parameters and mass assignment
- SQL injection in scheduling queries
- XSS in customer notes and job descriptions
- Rate limiting with `rack-attack` for quote submission
- CORS if exposing a public API
- Audit logging for sensitive actions

---

## Lesson 26: Testing Controllers and Requests
**Focus: Full-stack test coverage**

- Request specs for quote CRUD
- Testing role-based access with shared examples
- Testing job scheduling conflicts
- FactoryBot factories for customers, teams, jobs
- Capybara for customer-facing booking flow

---

## Lesson 27: Background Jobs with Sidekiq and Redis
**Focus: Production-grade async processing**

- Sidekiq setup and Redis configuration
- Jobs: `SendQuoteNotification`, `RemindTeamOfJob`, `GenerateDailyReport`
- Sidekiq UI and monitoring
- Retry strategies and dead-set handling
- Testing Sidekiq jobs with `rspec-sidekiq`
- When to use Solid Queue vs. Sidekiq in your own decisions

---

## Lesson 28: Mailers, Notifications, and Webhooks
**Focus: Keeping customers and teams informed**

- `QuoteMailer`, `JobConfirmationMailer`, `InvoiceMailer`
- Background delivery with Sidekiq
- SMS notifications via Twilio (optional)
- Webhook delivery for external integrations
- Email testing with `letter_opener`

---

## Lesson 29: File Uploads and Service Documentation
**Focus: Attaching work orders and inventory photos**

- ActiveStorage for job photos and receipts
- Direct uploads from the browser
- Image processing with `image_processing` gem
- Document variants (thumbnail, preview)
- Storage backends: local for dev, S3 for production

---

## Lesson 30: Caching with Redis
**Focus: Performance under real load**

- Redis as a cache store in Rails
- Fragment caching for team dashboards
- Low-level caching for quote calculations
- Cache invalidation when inventory changes
- Russian doll caching with Turbo
- Monitoring cache hit rates

---

## Lesson 31: API Design and Serialization
**Focus: Exposing Brite to external clients**

- JSON:API spec with `jsonapi-serializer`
- Namespaced routes: `/api/v1/quotes`, `/api/v1/jobs`
- Versioning strategy
- Error format consistency
- API authentication with Bearer tokens
- OpenAPI documentation

---

## Lesson 32: Hotwire for Real-Time Scheduling
**Focus: Live updates without custom JavaScript**

- Turbo Drive for booking flow
- Turbo Streams for live job status updates
- Stimulus for time-picker and conflict detection
- Real-time dashboard for team leads
- Comparing Turbo Streams to ActionCable for this use case

---

## Lesson 33: Containerization and Deployment
**Focus: Production Docker with Sidekiq and Redis**

- Multi-service Docker Compose (Rails, PostgreSQL, Redis, Sidekiq)
- Dockerfile optimized for Rails 8
- Kamal deployment with Sidekiq as a separate service
- Environment variables and secrets
- Health checks for Redis and Sidekiq
- Zero-downtime deploys with Sidekiq draining

---

## Lesson 34: Monitoring and Observability
**Focus: Running Brite in production**

- Sentry setup and context enrichment
- Structured logging with `lograge`
- CloudWatch or Datadog for metrics
- Sidekiq Web UI for job monitoring
- Database query analysis and slow query logging
- Uptime and health checks

---

## Lesson 35: Advanced Patterns and Production Hardening
**Focus: Senior-level concerns**

- Database transactions and race conditions in scheduling
- Optimistic locking for job assignments
- Idempotency in webhook delivery
- Internationalization (i18n) for multi-region support
- Feature flags for gradual rollout
- Refactoring a legacy Sidekiq codebase
- Capacity planning and background job backpressure

---

## Guiding Principles

- All lessons tie back to the Vault banking domain
- Each lesson has hands-on code, not just theory
- We favor understanding *why* over memorizing *how*
- Production-readiness is considered from day one

## Stage 2 Guiding Principles

- The stack matches what you'll find in most production Rails shops today
- Every Sidekiq/Redis decision is contrasted with Stage 1's Rails 8 native approach
- The Brite domain is intentionally different from Vault so concepts transfer, not just muscle memory
- We cover operational concerns (monitoring, deployment, backpressure) because mid/senior devs are expected to own production behavior
