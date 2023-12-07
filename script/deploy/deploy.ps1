# Function to change to working directory (provided as a parameter)
function Change-WorkingDirectory {
  param($workingDirectory)

  if ($workingDirectory) {
    Write-Host "Changing working directory to $workingDirectory..."
    Set-Location $workingDirectory
  }
}

# Function to check if a package is installed
function Check-Package {
  param($packageName)

  if (!(Get-Package $packageName -ErrorAction SilentlyContinue)) {
    Write-Host "$packageName is not installed. Please install it and try again."
    exit 1
  } else {
    Write-Host "$packageName is installed."
  }
}

# Function to install dependencies
function Install-Dependencies {
  Write-Host "Installing dependencies..."
  bundle install
}

# Function to run database setup
function Run-DatabaseSetup {
  param($skipDbSetup)

  if ($skipDbSetup -ne "--skip-db-setup") {
    Write-Host "Running database setup..."
    bundle exec rake db:create db:migrate db:seed
  }
}

# Function to precompile assets
function Precompile-Assets {
  Write-Host "Precompiling assets..."
  bundle exec rake assets:precompile
}

# Function to gracefully stop the server
function Stop-Server {
  if (Test-Path tmp/pids/server.pid) {
    $serverPid = Get-Content tmp/pids/server.pid
    Write-Host "Stopping the server (PID: $serverPid)..."
    Stop-Process -Id $serverPid -ErrorAction SilentlyContinue
    Start-Sleep 5
  }
}

# Function to start the server
function Start-Server {
  Write-Host "Starting the server..."
  bundle exec rails server -p 80
}

# Exit on error
$ErrorActionPreference = "Stop"

# Change to working directory
Change-WorkingDirectory $args[0]

# Set path so Ruby/bundle is found
$env:PATH = "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\Git\cmd;C:\Ruby32-x64\bin;C:\Users\Matan\AppData\Local\Microsoft\WindowsApps;" + $env:PATH

# Set environment variables
$env:HOST = "cms.bvcog.org"
$env:LANG = "en_US.UTF-8"
$env:DB_USERNAME = "postgres"
$env:DB_PASSWORD = "bvcogcms"
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432"
$env:DB_NAME = "bvcog"
$env:DATABASE_URL = "postgres://$($env:DB_USERNAME):$($env:DB_PASSWORD)@$($env:DB_HOST):$($env:DB_PORT)/$($env:DB_NAME)"
$env:RAILS_ENV = "production"
$env:RACK_ENV = "production"
$env:RAILS_LOG_TO_STDOUT = "enabled"
$env:RAILS_SERVE_STATIC_FILES = "enabled"
$env:RAILS_MASTER_KEY = Get-Content config/master.key
$env:SECRET_KEY_BASE = (bundle exec rake secret)
$env:MAIL_ADDRESS = "bvcog-org.mail.protection.outlook.com"
$env:MAIL_PORT = 25
$env:MAIL_DEFAULT_FROM = "CMS@bvcog.org"
$env:MAIL_DOMAIN = "bvcog.org"
$env:MAIL_USERNAME = "cscan@bvcog.org"
$env:MAIL_PASSWORD = "cscan"

# Install dependencies
Install-Dependencies

# Run database setup if no --skip-db-setup flag is passed
Run-DatabaseSetup $args[1]

# Precompile assets
Precompile-Assets

# Stop the server gracefully
Stop-Server

# Start the server
Start-Server
