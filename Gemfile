source 'http://rubygems.org'

# General
gem 'rake', '0.9.2.2'
# C Ruby 1.8.7 requirement
gem 'rdoc', '3.12'
gem 'rdoc-data', '3.12'

######### Core
gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'

gem 'authlogic', '~> 3.1'
gem 'cucumber', '1.2.1'
gem 'declarative_authorization', '0.5.6'
gem 'nokogiri', '~> 1.5'
gem 'rack', '~> 1.4'
gem 'RedCloth', '4.2.2'
gem 'rubyzip', '0.9.1'
gem 'will_paginate', '~> 3.0'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'jquery-rails', '~> 2.1'
  gem 'colorbox-on-rails', '~> 0.0'
  gem 'jquery-ui-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

######### Database
gem 'pg', '0.14.1'

######## Monitoring
gem 'newrelic_rpm', '~> 3.5'

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
end

group :test do
  gem 'term-ansicolor'
  gem 'reek', '1.2.8'
  gem 'roodi', '2.0.1'
  gem 'rcov', :require => false

  gem 'cucumber-rails', '~> 1.3', :require => false
  gem 'capybara', '~> 1.1'
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner', '~> 0.9'
  gem 'selenium-webdriver', '~> 2.25'
  gem 'launchy', '~> 2.1'
end
