source "https://rubygems.org"

gem 'sinatra'
gem 'haml'
gem 'rake'
gem 'rack-flash3', :require => 'rack/flash'
gem "sinatra-contrib"

group :production do
  gem 'pg'
end

gem 'activerecord'
gem 'activesupport', :require => 'active_support/all'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'

group :development do
  gem 'sqlite3'
end
