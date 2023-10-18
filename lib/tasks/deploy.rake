# frozen_string_literal: true

namespace :deploy do
  desc 'Create default file storage directories'
  task create_file_storage: :environment do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/public/contracts"
      execute "mkdir -p #{shared_path}/public/reports"
    end
  end
end
