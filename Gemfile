source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.2"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.4"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.9', require: false

# Env Variables
gem 'figaro', '~> 1.2'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"


# Background Jobs
gem 'sidekiq', '~> 6.2', '>= 6.2.1'
gem 'sidekiq_alive', '~> 2.1', '>= 2.0.6'
gem 'sidekiq-cron', '~> 1.2'
gem 'sidekiq-failures', '~> 1.0'
gem 'sidekiq-status', '~> 1.1', '>= 1.1.4'
gem 'sidekiq-throttled', '~> 0.13'
gem 'sidekiq-unique-jobs', '~> 7.1', '>= 7.0.9'

group :development, :test do
gem 'irb'
  gem 'rdoc', '6.3.3'
  gem 'byebug', '~> 11.1', platforms: %i[mri mingw x64_mingw]
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.18'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 5.0'
end

group :development do
  gem 'listen', '~> 3.6'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]