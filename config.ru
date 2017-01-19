# encoding:utf-8

require 'bundler'
Bundler.require
require './app/main.rb'

use Rack::Session::Cookie, secret: 'aucaucauc'
run Sinatra::Application
