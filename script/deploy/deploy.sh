#!/bin/sh

# Script to deploy the Rails app in production locally

# Exit on error
set -e

# Set environment variables

# General settings
export HOST=localhost:3000
export LANG=en_US.UTF-8

# Database settings
export DATABASE_URL=postgres://localhost:5432/postgres

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

# Run database migrations
bundle exec rake db:create db:migrate db:seed

# Precompile assets
bundle exec rake assets:precompile

# Start the server
rails s


