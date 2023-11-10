<!-- Github Actions Build Status -->
![Build Status](https://github.com/BVCOG-Contract-Management/BVGOG-Contract-Manager/actions/workflows/ruby.yml/badge.svg)

<img src="./app/assets/images/bvcog-logo.png" alt="BVCOG Logo" width="200"/>

# BVCOG Contract Management System
Full-Stack source code for the BVCOG Contract Management Platform (CMS)

## Getting Started
### Prerequisites
* [Ruby](https://www.ruby-lang.org/en/downloads/) - Ruby 3.2.0
* [Rails](https://rubyonrails.org/) - Rails 7.1.0
* [PostgreSQL](https://www.postgresql.org/) - PostgreSQL 12.3
* [Make](https://www.gnu.org/software/make/manual/make.html) - Make 4.3
* [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) - heroku/8.4.2 wsl-x64 node-v16.19.0

If the current ruby version you are currently running is not 3.2.0 you can change it as follows:
```bash
/bin/bash --login
rvm use 3.2.0
```

## Installing for Local Development
1. Clone the repository
	```sh
	git clone
	```

2. Install dependencies
    ```sh
    make bundle
    ```
    or
    ```sh
    bundle install
    ```

3. Creating a local database
    ```sh
    make database
    ```
    or
    ```sh
    rm -f ./db/development.sqlite3
	rm -f ./db/test.sqlite3
	rails db:create
	rails db:migrate
	rails db:seed
    ```

4. Starting the Server
    ```sh
    make run
    ```
    or
    ```sh
    rails s
    ```

## Deploy to Production
1. Clone the repository
	```bash
	git clone
	```

2. Heroku configuration
   1. Install Heroku Command Line Interface
    ```bash
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    ```

   2. Login to Heroku
    ```bash
    heroku login -i
    ```
    
   3. Login to Heroku
    ```bash
    heroku login -i
    ```

   4. Create an app on Heroku
    ```bash
    heroku create bvcog
    ```

3. Edit credentials
    ```bash
    EDITOR=vim rails credentials:edit
    ```

## Testing
This project has both `cucumber` and `rspec` tests.
### Cucumber
```bash
bundle exec cucumber --profile default
```
or
```bash
make cucumber
```

### RSpec
```bash
bundle exec rspec spec
```
or
```bash
make rspec
```
## Login Credentials
We have different user account to be able to log into the local and production environment for testing.  
These can be found in [seeds.rb](./db/seeds.rb) but are included here as well.

### Dev/Test Users
For local development we have the following credentials
| User Access Level | Username               | password |
| ----------------- | ---------------------- | -------- |
| Admin             | admin@example.com      | password |
| Gatekeeper        | gatekeeper@example.com | password |
| User              | user@example.com       | password |

### Production Users
When deployed to Heroku, we have the following credentials.  
| User Access Level | Username                | password |
| ----------------- | ----------------------- | -------- |
| Admin             | admin@bvcogdev.com      | password |
| Gatekeeper        | gatekeeper@bvcogdev.com | password |
| User              | user@bvcogdev.com       | password |

## Notes
### Rails Master Key
The application requires the `ENV['MAIL_PASSWORD']` environment variable to be set in order to send emails.  
This is set in the [`config/credentials.yml.enc`](./config/credentials.yml.enc) file.  
This file is encrypted and can only be decrypted by the `config/master.key` file.  
The `master.key` file is not included in the repository for security reasons.  
If you need access to the `master.key` file, please contact BVCOG's IT Department.  
Otherwise, you can set the `ENV['MAIL_PASSWORD']` environment variable to a dummy value in order to run the application locally, or delete the `config/credentials.yml.enc` file and run `rails credentials:edit` to create a new one.

### RuboCop
This project uses RuboCop to ensure consistent coding standards and style across the codebase.  
The configuration setting for `rubocop` can be found in `./.rubocop.yml`. Edit it as you see fit.  
To run it use the following command:
```bash
bundle exec rubocop --config .rubocop.yml --autocorrect-all
```
or
```bash
make rubocop
```

### Makefile
A [makefile](./makefile) has been provided for your convience.  
Use/modify it as you see fit.