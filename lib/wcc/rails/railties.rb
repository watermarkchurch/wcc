class WCC::Railties < Rails::Railtie

  rake_tasks do
    Dir[File.join(File.dirname(__FILE__), "..", "..", "tasks", "*.rake")].each do |rake_file|
      load rake_file
    end
  end

end
