module WCC
  module RakeHelpers

    def self.db_config
      @config ||= YAML.load_file("config/database.yml")[ENV['RAILS_ENV'] || 'development'] || {}
    end

    def self.db_cmd_with_password(cmd, pw)
      `#{db_cmd_with_password_string(cmd, pw)}`
    end

    def self.db_cmd_with_password_string(cmd, pw)
      %{PGPASSWORD="#{pw}" #{cmd.join(" ")}}
    end

    def self.postgresql?
      db_config["adapter"] == "postgresql"
    end

    def self.mysql?
      db_config["adapter"] == "mysql"
    end

  end
end

namespace :db do

  desc "Drops, creates, migrates, seeds dev DB and prepares test DB"
  task :rebuild => ["db:drop", "db:create", "db:migrate", "db:seed", "db:test:prepare"]

end

