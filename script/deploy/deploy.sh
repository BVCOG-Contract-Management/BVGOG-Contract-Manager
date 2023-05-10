#!/bin/bash

# Function to check if a package is installed
check_package() {
  if ! dpkg -s "$1" >/dev/null 2>&1; then
    echo "$1 is not installed. Please install it with 'sudo apt-get install $1' and try again."
    exit 1
  else
    echo "$1 is installed."
  fi
}

# Function to install dependencies
install_dependencies() {
  echo "Installing dependencies..."
  bundle install
}

# Function to run database setup
run_database_setup() {
  if [ "$1" != "--skip-db-setup" ]; then
    echo "Running database setup..."
    bundle exec rake db:create db:migrate db:seed
  fi
}

# Function to precompile assets
precompile_assets() {
  echo "Precompiling assets..."
  bundle exec rake assets:precompile
}

# Function to clear crontab
clear_crontab() {
  echo "Clearing crontab..."
  bundle exec whenever --clear-crontab
}

# Function to update crontab
update_crontab() {
  echo "Updating crontab..."
  bundle exec whenever --update-crontab
}

# Function to gracefully stop the server
stop_server() {
  if [ -f tmp/pids/server.pid ]; then
    local server_pid=$(cat tmp/pids/server.pid)
    echo "Stopping the server (PID: $server_pid)..."
    kill "$server_pid" || true
    sleep 5
  fi
}

# Function to start the server
start_server() {
  echo "Starting the server..."
  bundle exec rails server --daemon
}

# Exit on error
set -e

# Check required packages
check_package "libpq-dev"

# Set environment variables
export HOST=54.173.238.151:3000
export LANG=en_US.UTF-8
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=bvcog
export DATABASE_URL=postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME
export RAILS_ENV=production
export RACK_ENV=production
export RAILS_LOG_TO_STDOUT=enabled
export RAILS_SERVE_STATIC_FILES=enabled
export RAILS_MASTER_KEY=$(cat config/master.key)
export SECRET_KEY_BASE=$(bundle exec rake secret)
export MAIL_ADDRESS=smtp.sendgrid.net
export MAIL_DEFAULT_FROM=matan@matanbroner.com
export MAIL_DOMAIN=matanbroner.com
export MAIL_USERNAME=apikey

# Install dependencies
install_dependencies

# Run database setup if no --skip-db-setup flag is passed
run_database_setup "$1"

# Precompile assets
precompile_assets

# Clear the crontab
clear_crontab

# Update the crontab
update_crontab

# Stop the server gracefully
stop_server

# Start the server
start_server
