module WCC
  module RakeHelpers

    def self.db_config
      if db_config_file_data.respond_to?(:configs_for)
        configs = db_config_file_data.configs_for(env_name: ENV['RAILS_ENV'] || 'development')
        configs.any? ? configs[0].configuration_hash : {}
      else
        db_config_file_data[ENV['RAILS_ENV'] || 'development'] || {}
      end
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
        # We only go down this path if DATABASE_URL is not set, otherwise we would lode the config via ActiveRecord.
        # In psych 3.1 they changed the "aliases" param to be a kwarg instead of a positional argument.
        raise 'Psych version < 3.1.0 not supported' if Psych::Version < '3.1.0'
        @yaml_file ||= YAML.safe_load(ERB.new(File.read('config/database.yml' )).result, aliases: true)
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
