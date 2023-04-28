namespace :deploy do
    desc 'Create default file storage directories'
    task :create_directories do
      execute :mkdir, '-p', 'public/contracts'
      execute :mkdir, '-p', 'public/reports'
    end
  end
  