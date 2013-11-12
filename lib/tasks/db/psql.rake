namespace :db do

  desc 'Drop connections to this database so we can drop it'
  task :new_drop => :environment do
    ActiveRecord::Base.connection.execute %{
      SELECT
        pg_terminate_backend(pid)
      FROM
        pg_stat_activity
      WHERE -- don't kill my own connection!
        datname = '#{WCC::RakeHelpers.db_config['database']}' AND
        pid <> pg_backend_pid();
    }
    Rake::Task['db:old_drop'].invoke
  end
  alias_task 'db:old_drop', 'db:drop'
  alias_task 'db:drop', 'db:new_drop'

  desc 'Dump the database to the specified file'
  task :dump, :file do |t, args|
    raise "file argument required" unless args[:file]
    db_config = WCC::RakeHelpers.db_config
    command = [
      "pg_dump",
      "--username=#{db_config['username']}",
      "--host=#{db_config['host']}",
      "#{db_config['database']}",
      "> #{args[:file]}"
    ]
    WCC::RakeHelpers.db_cmd_with_password(command, db_config['password'])
  end

  desc 'Restore the datbase from the specified file'
  task :restore, :file do |t, args|
    raise "file argument required" unless File.exists?(args[:file])
    command = [
      "cat #{args[:file]} | psql",
      WCC::RakeHelpers.db_config['database'],
    ].join(" ")
    `#{command}`
  end

end

