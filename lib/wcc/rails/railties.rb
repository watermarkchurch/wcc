class WCC::Railties < Rails::Railtie
  initializer 'wcc.configure_rails_init' do
    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'WCC'
    end
  end

  rake_tasks do
    Dir.glob(File.join(WCC::BASE_GEM_LIB_PATH, "tasks", "**", "*.rake")).sort.each do |rake|
      load rake
    end
  end
end
