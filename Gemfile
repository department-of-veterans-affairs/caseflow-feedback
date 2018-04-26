# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
source ENV["GEM_SERVER_URL"] || "https://rubygems.org"

gem "caseflow", git: "https://github.com/department-of-veterans-affairs/caseflow-commons", branch: "issue4932"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "5.1.5"
# Use sqlite3 as the database for Active Record
gem "activerecord-jdbcsqlite3-adapter", platforms: :jruby
gem "sqlite3", platforms: [:ruby, :mswin, :mingw, :mswin, :x64_mingw]
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"

gem "prometheus-client"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Application server: Puma
# Puma was chosen because it handles load of 40+ concurrent users better than Unicorn and Passenger
# Discussion: https://github.com/18F/college-choice/issues/597#issuecomment-139034834
gem "puma", "~> 2.16.0"

gem "httparty"

gem "rails_stdout_logging"

# Error reporting to Sentry
gem "sentry-raven"

# Pagination for Admin page
gem "will_paginate"

# Github API
gem "octokit", "~> 4.0"

gem "pg", platforms: :ruby

# Explicitly adding USWDS gem until it"s published and we can
# include it via commons
gem "uswds-rails", git: "https://github.com/18F/uswds-rails-gem.git"

group :development, :test do
  gem "faker"
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: :ruby
  gem "capybara-screenshot"
  gem "pry"

  gem "rb-readline"

  # Used to colorize output for rake tasks
  gem "rainbow"

  # Linters
  gem "jshint", platforms: :ruby
  gem "rubocop", "~> 0.52.1", require: false
  gem "scss_lint", require: false

  # Security scanners
  gem "brakeman"
  gem "bundler-audit"

  # Testing tools
  gem "capybara"
  gem "dotenv-rails"
  gem "guard-rspec"
  gem "launchy"
  gem "rspec"
  gem "rspec-rails"
  gem "simplecov"
  gem "sniffybara", git: "https://github.com/department-of-veterans-affairs/sniffybara.git"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 3.0", platforms: :ruby

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem "spring", platforms: :ruby

  # Include the IANA Time Zone Database on Windows, where Windows doens"t ship with a timezone database.
  # POSIX systems should have this already, so we"re not going to bring it in on other platforms
  gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
end
# rubocop:enable Metrics/LineLength
