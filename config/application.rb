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
    # ヘルパの自動読み込み制限
    config.action_controller.include_all_helpers = false
    # タイムゾーンを日本時間に設定
    config.time_zone = 'Asia/Tokyo'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end