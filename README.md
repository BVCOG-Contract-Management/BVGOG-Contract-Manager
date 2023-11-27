<!-- Github Actions Build Status -->
![Build Status](https://github.com/BVCOG-Contract-Management/BVGOG-Contract-Manager/actions/workflows/ruby.yml/badge.svg)

<img src="./app/assets/images/bvcog-logo.png" alt="BVCOG Logo" width="200"/>

# BVCOG Contract Management System
Full-Stack source code for the BVCOG Contract Management Platform (CMS)

## Getting Started
### Prerequisites
These instructions assume that you are operating Ubuntu 22.04 either on a Linux machine or using Windows Submachine for Linux.  
Install the following using your prefered method of instilation.
* [Ruby](https://www.ruby-lang.org/en/downloads/) - Ruby 3.2.0
* [Rails](https://rubyonrails.org/) - Rails 7.1.0
* [Make](https://www.gnu.org/software/make/manual/make.html) - Make 4.3
* [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) - heroku/8.4.2 wsl-x64 node-v16.19.0
* [PostgreSQL](https://www.postgresql.org/) - PostgreSQL 12.3

If the current ruby version you are currently running is not 3.2.0 you can change it as follows:
```bash
/bin/bash --login
rvm use 3.2.0
```
or
```bash
rbenv local 3.2.0
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
You will need to be added to the GitHub repository in order to deploy the project.  
Please contact the [Spring 2023](#spring-2023) team or the Professor to be added.
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

   3. Create an app on Heroku
    ```bash
    heroku create bvcog-yyyy-semester
    ```
    Where `yyyy-semester` is the current year and semester. i.e. `2024-spring`.

3. Set the Rails Master Key
   Run the command
   ```bash
   heroku config:set RAILS_MASTER_KEY=<BVCOG-master-key>
   ```
   See [Rails Master Key](#rails-master-key) for more information.

4. Edit credentials
    ```bash
    EDITOR=vim rails credentials:edit
    ```
    Ensure that `ENV['MAIL_PASSWORD']` is set, it if is not, please look through the git commit history to find the original credential files.  
    See [Rails Master Key](#rails-master-key) for more information.

## Testing
This project has both `cucumber` and `rspec` tests.
### Cucumber
```bash
bundle exec cucumber --profile default --out ./out.log
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
These can be found in [seeds.rb](./db/seeds.rb) but are included here as well for convenience.

### Dev/Test Users
For local development we have the following credentials:
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

These can be found in [`db/seeds.rb`](./db/seeds.rb) but have been included here for your convinence.  
Note: the production seeds will be overriden when you deliver the product to the customer.  

## Notes
### Rails Master Key
The application requires the `ENV['MAIL_PASSWORD']` environment variable to be set in order to send emails.  
This is set in the [`config/credentials.yml.enc`](./config/credentials.yml.enc) file.  
This file is encrypted and can only be decrypted by the `config/master.key` file.  
The `master.key` file is not included in the repository for security reasons.  
If you need access to the `master.key` file, please contact BVCOG's IT Department.  
You will need BVCOG's `master.key` you **CAN NOT** generate your own.

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

### Script
A [makefile](./makefile) has been provided for your convience.  
Use/modify it as you see fit.

A [deploy script](./script/deploy/deploy.sh) has been provided for your convience.  
Use/modify it as you see fit.  
Note: the [Fall 2023](#fall-2023) team deprecated this script, if you have questions about it, ask the [Spring 2023](#spring-2023) team

## Contacting the Team
Please contact the most recent team.

### Fall 2023
| Team member          | Email                 |
| -------------------- | --------------------- |
| Huy Lai              | lai.huy.075@gmail.com |
| Thomas Manzini       | tom.m@nzini.com       |
| Shreya Gubbi Prakash | shreyagp@tamu.edu     |
| Neha Manghnani       | nehajm@tamu.edu       |

### Spring 2023
| Team member      | Email                 |
| ---------------- | --------------------- |
| Liam Berney      | liamrberney@gmail.com |
| Matan Broner     | matanbroner@gmail.com |
| Chrysanthos Pepi | cpepi001@outlook.com  |
| Hanrui Chen      | No Email Given        |
