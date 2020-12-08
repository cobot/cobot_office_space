# What it does

Allows Admins to manage inventory to track who is using what, e.g. lockers, offices..

* allow creation of groups of inventory items
* enable assignment of memberships to inventory items (one member to many items)

## Deployment

The app is currently automatically deployed on heroku as [officespace](https://dashboard.heroku.com/apps/officespace)

## Setup

* setup DB
  * you need to have postgres installed
  * `rails db:create`
  * `rails db:schema:load`

## Testing

Test can be run via `bundle exec rake`