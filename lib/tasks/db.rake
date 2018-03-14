module WCC
  module RakeHelpers

    def self.db_config
      db_config_file_data[ENV['RAILS_ENV'] || 'development'] || {}
    end

    def self.db_cmd_with_password(cmd, pw)
      `#{db_cmd_with_password_string(cmd, pw)}`
    end

    def self.db_cmd_with_password_string(cmd, pw)
      %{PGPASSWORD='#{pw}' #{cmd.join(' ')}}
    end

    def self.postgresql?
      db_config['adapter'] == 'postgresql'
    end

    def self.mysql?
      db_config['adapter'] == 'mysql'
    end

    def self.db_config_file_data
      if defined?(ActiveRecord::Base) && ActiveRecord::Base.configurations.present?
        ActiveRecord::Base.configurations
      else
        @yaml_file ||= YAML.load(ERB.new(File.read('config/database.yml' )).result)
      end
    rescue SystemCallError
      {}
    end
  end
end

namespace :db do
  desc 'Drops, creates, migrates, seeds dev DB and prepares test DB'
  task rebuild: %w[db:drop db:create db:migrate db:seed db:test:prepare]
end
