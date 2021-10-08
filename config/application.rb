require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NPChecker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # デフォルトのロケールを日本（ja）に設定
    config.i18n.default_locale = :ja
    # Accept-Languageに有効でないロケール情報が入っていた場合のデフォルト値を設定
    config.i18n.fallbacks = [:ja]
    # タイムゾーンを日本時間に設定
    config.time_zone = 'Asia/Tokyo'
    # ヘルパの自動読み込み制限
    config.action_controller.include_all_helpers = false

    # Setting for http_accept_language
    class HTTPAcceptLanguageToI18nLocale
      def initialize(app)
        @app = app
      end
    
      def call(env)
        I18n.locale = env.http_accept_language.compatible_language_from(I18n.available_locales)
        @app.call(env)
      end
    end
    
    config.middleware.use HttpAcceptLanguage::Middleware
    config.middleware.use HTTPAcceptLanguageToI18nLocale

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end