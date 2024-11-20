# Setup
0. Ensure you have ruby 3.3.4 installed, Postgres and Redis as well
1. Install gems: `bundle install`
2. Create and prepopulate db: `rails db:create db:migrate db:seed`
3. Run server: `rails s`
4. Run sidekiq: `bundle exec sidekiq`

Once everything is setup you can use APIs with following test creds via Basic auth:
Marketplace API: username: `samplebuyer`, password: `password456`
Platform API: username: `businessowner@test.com`, password: `password123`

# API endpoints
## Marketplace API
1. List organizations: `GET /marketplace/api/v1/organizations`
2. List orgniazation orders: `GET /marketplace/api/v1/organizations/:id/share_orders`
3. Create share order: `POST /marketplace/api/v1/share_orders`
### Example body
```json
{
  "shares_amount": 1000,
  "price_per_share": 10,
  "organization_id": 1
}
```

### Platfrom API

1. List current organization orders `GET /platform/api/v1/share_orders`
2. Accept order `POST /platform/api/v1/share_orders/:id/accept`
3. Reject order `POST /platform/api/v1/share_orders/:id/reject`
