require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module ShortestPath
  class Application < Rails::Application
    config.i18n.available_locales = [:pt, :ne]
    config.i18n.default_locale = :pt
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml').to_s]
    config.time_zone = 'Brasilia'
  end
end
