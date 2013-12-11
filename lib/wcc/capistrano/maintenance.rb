Capistrano::Configuration.instance(true).load do |instance|

  after 'deploy:update_code', 'deploy:web:move_503_from_release_to_shared'

  namespace :deploy do
    namespace :web do

      task :move_503_from_release_to_shared do
        run "mv #{release_path}/public/503.html #{shared_path}/503.html"
      end

      desc 'Take the site out of maintenance mode'
      task :enable do
        run "mv #{current_path}/public/503.html #{shared_path}/503.html"
      end

      desc 'Put the site into maintenance mode'
      task :disable do
        run "cp #{shared_path}/503.html #{current_path}/public/503.html"
      end

    end
  end
end
