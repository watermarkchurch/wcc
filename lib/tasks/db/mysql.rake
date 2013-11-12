namespace :db do

  desc 'Dump the database to the specified file'
  task :dump, :file do |t, args|
    raise "file argument required" unless args[:file]
    db_config = WCC::RakeHelpers.db_config
    command = [
      "mysqldump",
      "--user=#{db_config['username']}",
      "--password=#{db_config['password']}",
      "#{db_config['database']}",
      "> #{args[:file]}"
    ]
    WCC::RakeHelpers.db_cmd_with_password(command)
  end

  desc 'Restore the datbase from the specified file'
  task :restore, :file do |t, args|
    raise "file argument required" unless File.exists?(args[:file])
    db_config = WCC::RakeHelpers.db_config
    command = [
      "cat #{args[:file]} | mysql --user=#{db_config['username']} --password=#{db_config['password']}",
      db_config['database'],
    ].join(" ")
    `#{command}`
  end

end
