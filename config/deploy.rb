# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'freego'
set :repo_url, 'git@github.com:fmachella/freegonrails.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "~/deploy/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :rails_env, :production

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  before 'deploy:assets:backup_manifest', :copy_manifest do
    on roles(:web) do
      within release_path do
        purged_filename = capture(:ls,"public/assets/.sprockets-manifest*").scan(/.*(manifest-.*)/)[0][0].to_s
        execute :cp,
                release_path.join('public',fetch(:assets_prefix),'.sprockets-manifest*'),
                release_path.join('public',fetch(:assets_prefix),purged_filename)
      end
    end
  end

end
