if WCC::RakeHelpers.postgresql?
  namespace :db do
    desc 'Drop connections to the pg database'
    task drop_pg_connections: :environment do
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
    task :dump, [:file] => :environment do |_t, args|
      raise 'file argument required' unless args[:file]
      db_config = WCC::RakeHelpers.db_config
      command = [
        'pg_dump',
        "--username=#{db_config['username']}",
        "--host=#{db_config['host']}",
        (db_config['database']).to_s,
        "> #{args[:file]}"
      ]
      WCC::RakeHelpers.db_cmd_with_password(command, db_config['password'])
    end

    desc 'Restore the pg datbase from the specified file'
    task :restore, [:file] => :environment do |_t, args|
      raise 'file argument required' unless File.exist?(args[:file])
      db_config = WCC::RakeHelpers.db_config

      puts "Logging db_config: #{db_config.inspect}"

      case File.extname(args[:file])
      when '.sql'
        command = [
          "cat #{args[:file]} |",
          WCC::RakeHelpers.db_cmd_with_password_string(['psql'], db_config['password']),
          db_config['username'] ? "--username=#{db_config['username']}" : nil,
          db_config['host'] ? "--host=#{db_config['host']}" : nil,
          db_config['database']
        ].compact.join(' ')

        puts "Running Command: #{command.join(' ')}"

        `#{command}`
      when '.dump'
        command = [
          'pg_restore',
          '--verbose', '--clean', '--no-acl', '--no-owner',
          db_config['username'] ? ['-U', db_config['username']] : nil,
          db_config['host'] ? ['-h', db_config['host']] : nil,
          '-d', db_config['database'],
          args[:file]
        ].flatten.compact

        # system("pg_restore --verbose --clean --no-owner --no-acl --host #{host} --username #{user}  --dbname #{db} #{dump_file}")

        puts "Running Command: #{command.join(' ')}"

        system(*command)
      end
      Rake::Task['db:after_restore'].invoke(args[:file])
    end

    task :after_restore, :file
  end
end
