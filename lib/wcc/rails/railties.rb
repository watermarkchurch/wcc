class WCC::Railties < Rails::Railtie

  rake_tasks do
    Dir[File.join(File.dirname(__FILE__), "..", "..", "tasks", "*.rake")].sort.each do |rake_file|
      load rake_file
    end
  end

  initializer 'wcc.configure_rails_init' do
    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'WCC'
    end
  end

end
