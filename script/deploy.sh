# Script to deploy the Rails app in production locally

#!/usr/bin/env bash

# Exit on error
set -e

# Set environment variables

# General settings
export HOST=localhost:3000
export LANG=en_US.UTF-8

# Database settings
export DATABASE_URL=postgres://localhost:5432/your_database_name

# Rails environment
export RAILS_ENV=production
export RACK_ENV=production
export RAILS_LOG_TO_STDOUT=enabled
export RAILS_SERVE_STATIC_FILES=enabled
export RAILS_MASTER_KEY=your_master_key
export SECRET_KEY_BASE=$(bundle exec rake secret)

# SMTP settings
export MAIL_ADDRESS=your_mail_address
export MAIL_DEFAULT_FROM=your_default_from_address
export MAIL_DOMAIN=your_mail_domain

# Install gems
bundle install --deployment --without development test

# Run database migrations
bundle exec RAILS_ENV=production rake db:create db:migrate db:seed

# Precompile assets
bundle exec rake assets:precompile RAILS_ENV=production

# Start the server
RAILS_ENV=production rails s


