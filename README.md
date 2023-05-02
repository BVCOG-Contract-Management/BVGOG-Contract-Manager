# BVGOG-Contract-Manager
Full-Stack source code for the BVCOG Contract Management Platform (CMS)

## Getting Started
### Prerequisites
* [Ruby](https://www.ruby-lang.org/en/downloads/) - Ruby 3.2.0
* [Rails](https://rubyonrails.org/) - Rails
* [PostgreSQL](https://www.postgresql.org/) - PostgreSQL 12.3

### Installing for Local Development
1. Clone the repository
```
git clone
```
2. Install dependencies
```
bundle install
```
3. Create the database
```
rails db:create
```
4. Run the migrations
```
rails db:migrate
```
5. Seed the database
```
rails db:seed
```
6. Start the server
```
rails s
```

## Deploy to Production Locally
### Linux
1. Clone the repository
```
git clone
```
2. Run `deploy.sh`
```
./script/deploy/deploy.sh
```

## Notes
* The `deploy.sh` script is used to deploy the application to production. It is not used for local development.
* The application requires the `ENV['MAIL_PASSWORD']` environment variable to be set in order to send emails. This is set in the `config/credentials.yml.enc` file. This file is encrypted and can only be decrypted by the `config/master.key` file. The `master.key` file is not included in the repository for security reasons. If you need access to the `master.key` file, please contact the repository owner. Otherwise, you can set the `ENV['MAIL_PASSWORD']` environment variable to a dummy value in order to run the application locally, or delete the `config/credentials.yml.enc` file and run `rails credentials:edit` to create a new one.

## Testing
### Cucumber
1. Run the tests
```
cucumber
```
### RSpec
1. Run the tests
```
rspec
```