# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rake', '~> 13.0'

group :development do
  gem 'pry', '~> 0.14.2'
  gem 'rubocop', '~> 0.80' # if not running rubocop in the CI, we can let it as a development dependency
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
end
