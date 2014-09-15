namespace :db do

  desc 'Drop connections to the pg database'
  task :drop_pg_connections => :environment do
    ActiveRecord::Base.connection.execute %{
      SELECT
        pg_terminate_backend(pid)
      FROM
        pg_stat_activity
      WHERE -- don't kill my own connection!
        datname = '#{WCC::RakeHelpers.db_config['database']}' AND
        pid <> pg_backend_pid();
    }
  end
  Rake::Task['db:drop'].enhance ['db:drop_pg_connections']

  desc 'Dump the pg database to the specified file'
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

  desc 'Restore the pg datbase from the specified file'
  task :restore, :file do |t, args|
    raise "file argument required" unless File.exists?(args[:file])
    db_config = WCC::RakeHelpers.db_config
    command = [
      "cat #{args[:file]} | psql",
      db_config['username'] ? "--username=#{db_config['username']}" : nil,
      db_config['host'] ? "--host=#{db_config['host']}" : nil,
      db_config['database'],
    ].compact.join(" ")
    `#{command}`
    Rake::Task['db:after_restore'].invoke(args[:file])
  end

  task :after_restore, :file

end if WCC::RakeHelpers.postgresql?

