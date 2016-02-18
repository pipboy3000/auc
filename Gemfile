source "https://rubygems.org"
ruby '2.3.0'

gem 'sinatra'
gem 'haml'
gem 'rake'
gem 'rack-flash3', :require => 'rack/flash'
gem "sinatra-contrib"

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'test-unit'
  gem 'rack-test'
end

gem 'activerecord'
gem 'activesupport', :require => 'active_support/all'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'

