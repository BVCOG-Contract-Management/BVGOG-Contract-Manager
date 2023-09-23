<!-- Github Actions Build Status -->
![Build Status](https://github.com/BVCOG-Contract-Management/BVGOG-Contract-Manager/actions/workflows/ruby.yml/badge.svg)

<img src="./app/assets/images/bvcog-logo.png" alt="BVCOG Logo" width="200"/>

# BVCOG Contract Management System
Full-Stack source code for the BVCOG Contract Management Platform (CMS)

## Getting Started
### Prerequisites
* [Ruby](https://www.ruby-lang.org/en/downloads/) - Ruby 3.2.0
* [Rails](https://rubyonrails.org/) - Rails
* [PostgreSQL](https://www.postgresql.org/) - PostgreSQL 12.3

If the current ruby version you are currently running is not 3.2.0 you can change it as follows:
```bash
/bin/bash --login
rvm use 3.2.0
```

### Installing for Local Development
1. Clone the repository
	```bash
	git clone
	```

2. Install dependencies
	```bash
	bundle install
	```

3. Create the database
	```bash
	rails db:create
	```

4. Run the migrations
	```bash
	rails db:migrate
	```

5. Seed the database
	```bash
	rails db:seed
	```

6. Start the server
	```bash
	rails s
	```

A makefile has been provided for your convience.  
Running `make database` will create a local database.

## Deploy to Production Locally
### Linux
1. Clone the repository
	```bash
	git clone
	```

2. Run `deploy.sh`
	```bash
	./script/deploy/deploy.sh
	```

## Notes
* The `deploy.sh` script is used to deploy the application to production. It is not used for local development.
* The application requires the `ENV['MAIL_PASSWORD']` environment variable to be set in order to send emails. This is set in the `config/credentials.yml.enc` file. This file is encrypted and can only be decrypted by the `config/master.key` file. The `master.key` file is not included in the repository for security reasons. If you need access to the `master.key` file, please contact BVCOG. Otherwise, you can set the `ENV['MAIL_PASSWORD']` environment variable to a dummy value in order to run the application locally, or delete the `config/credentials.yml.enc` file and run `rails credentials:edit` to create a new one.
* A makefile has been provided for your convience. Use it as you see fit.

## Testing
### Cucumber
1. Run the tests
	```bash
	cucumber
	```

### RSpec
1. Run the tests
	```bash
	rspec
	```