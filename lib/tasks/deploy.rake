namespace :deploy do
    desc 'Create default file storage directories'
    task :create_directories do
      on roles(:app) do
        within release_path do
          execute :mkdir, '-p', 'public/contracts'
          execute :mkdir, '-p', 'public/reports'
        end
      end
    end
  end
  