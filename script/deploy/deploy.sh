#!/bin/sh

# Script to deploy the Rails app in production locally

# Exit on error
set -e

# Set environment variables

# General settings
export HOST=54.173.238.151:3000
export LANG=en_US.UTF-8

# Database settings
export DATABASE_URL=postgres://localhost:5432/bvcog

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

# Install PSQL client
apt-get install libpq-dev

# Run database setup if no --skip-db-setup flag is passed
if [ "$1" != "--skip-db-setup" ]; then
  bundle exec rake db:create db:migrate db:seed
fi

# Precompile assets
bundle exec rake assets:precompile

# Start the server
rvmsudo rails s -p 80


