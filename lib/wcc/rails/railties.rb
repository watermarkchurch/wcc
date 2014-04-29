class WCC::Railties < Rails::Railtie

  initializer 'wcc.configure_rails_init' do
    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'WCC'
    end
  end

end
