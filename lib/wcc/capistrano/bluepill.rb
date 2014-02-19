Capistrano::Configuration.instance(true).load do |instance|

  set :bluepill_path, "/opt/rbenv/shims/bluepill"
  after "deploy:restart", "deploy:workers:restart"

  namespace :deploy do
    namespace :workers do

      desc 'Restart workers in :bluepill_application'
      task :restart, :roles => :bg, :except => { :no_release => true } do
        sudo "#{fetch :bluepill_path} #{fetch :bluepill_application} restart"
      end

      desc 'Stop workers in :bluepill_application'
      task :stop, :roles => :bg, :except => { :no_release => true } do
        sudo "#{fetch :bluepill_path} #{fetch :bluepill_application} stop"
      end

      desc 'Start workers in :bluepill_application'
      task :start, :roles => :bg, :except => { :no_release => true } do
        sudo "#{fetch :bluepill_path} #{fetch :bluepill_application} start"
      end

    end
  end

end
