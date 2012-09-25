# encoding:utf-8

require "rubygems"
require "bundler"
Bundler.require
require "./web.rb"

use Rack::Session::Cookie, secret: 'toystoystoys'
use Rack::Flash

run Sinatra::Application
