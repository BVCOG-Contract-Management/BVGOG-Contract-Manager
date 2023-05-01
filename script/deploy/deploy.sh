#!/bin/sh

# Script to deploy the Rails app in production locally

# Exit on error
set -e

# Fail if libpq-dev is not installed
if ! dpkg -s libpq-dev >/dev/null 2>&1; then
  echo "libpq-dev is not installed. Please install it with 'sudo apt-get install libpq-dev' and try again."
  exit 1
else 
    echo "libpq-dev is installed."
    fi
fi

# Set environment variables

# General settings
export HOST=54.173.238.151:3000
export LANG=en_US.UTF-8

# Database settings
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=bvcog
export DATABASE_URL=postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME

# Rails environment
export RAILS_ENV=production
export RACK_ENV=production
export RAILS_LOG_TO_STDOUT=enabled
export RAILS_SERVE_STATIC_FILES=enabled
export RAILS_MASTER_KEY=$(cat config/master.key)
export SECRET_KEY_BASE=$(bundle exec rake secret)

# SMTP settings
export MAIL_ADDRESS=smtp.sendgrid.net
export MAIL_DEFAULT_FROM=matan@matanbroner.com
export MAIL_DOMAIN=matanbroner.com
export MAIL_USERNAME=apikey

# Install dependencies
bundle install

# Run database setup if no --skip-db-setup flag is passed
if [ "$1" != "--skip-db-setup" ]; then
  bundle exec rake db:create db:migrate db:seed
fi

# Precompile assets
bundle exec rake assets:precompile

# Start the server in the background
bundle exec rails server --daemon


