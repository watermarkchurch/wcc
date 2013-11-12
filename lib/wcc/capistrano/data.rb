Capistrano::Configuration.instance(true).load do |instance|

  namespace :data do

    desc 'Restore the production database to the local development database'
    task :restore, roles: :db, only: { primary: true } do
      name = "db_dump_#{Time.now.strftime("%Y%m%d_%H%M%S")}.sql"
      begin
        run "cd #{current_path}; bundle exec rake db:dump[#{current_path}/tmp/#{name}] RAILS_ENV=#{fetch :stage}"
        get "#{current_path}/tmp/#{name}", "tmp/#{name}"
        `rake db:drop db:create db:restore[tmp/#{name}]`
      ensure
        run "rm -f tmp/#{name}"
        `rm -f tmp/#{name}`
      end
    end

  end

end
