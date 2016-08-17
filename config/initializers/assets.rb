# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'


# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
#config.assets.paths << Rails.root.join('/app/assets/fonts')
#Rails.application.config.assets.paths << Rails.root.join('/app/assets/materialize')
#Rails.application.config.assets.paths << Rails.root.join('/app/assets/fullcalendar')
#Rails.application.config.assets.precompile += %w( screen.css )

#Rails.application.config.assets.precompile += %w( dog.css )

%w( home users user_sessions password_resets materialize.min authentication editSettings fullcalendar dog wallpost messaging images picture connections).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js.coffee", "#{controller}.css"]
end