# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "log/cron_log.log"
env :PATH, ENV['PATH']
env :HOST, ENV['HOST']
env :DATABASE_URL, ENV['DATABASE_URL']
env :RAILS_ENV, ENV['RAILS_ENV']
env :RAILS_MASTER_KEY, ENV['RAILS_MASTER_KEY']
env :SECRET_KEY_BASE, ENV['SECRET_KEY_BASE']
env :RAILS_SERVE_STATIC_FILES, ENV['RAILS_SERVE_STATIC_FILES']
env :RAILS_LOG_TO_STDOUT, ENV['RAILS_LOG_TO_STDOUT']
env :MAIL_ADDRESS, ENV['MAIL_ADDRESS']
env :MAIL_DEFAULT_FROM, ENV['MAIL_DEFAULT_FROM']
env :MAIL_DOMAIN, ENV['MAIL_DOMAIN']
env :MAIL_USERNAME, ENV['MAIL_USERNAME']


EVERY_DAY_AT_5_AM = "0 5 * * *"
FIRST_OF_EACH_MONTH = "0 0 1 * *"

# Send expiry reminders for contracts every day
# every EVERY_DAY_AT_5_AM do
#     rake "contracts:send_expiration_reminders"
# end

# Send expiration reports once a month
every FIRST_OF_EACH_MONTH do
    rake "contracts:send_expiration_reports"
end

# Export contracts once a month
every FIRST_OF_EACH_MONTH do
    rake "contracts:export_all_contract_data"
end

# Test task every minute
# every 1.minute do
#     rake "contracts:test"
# end