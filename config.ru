# encoding:utf-8

require "rubygems"
require "bundler"
Bundler.require
require "./web.rb"

run Sinatra::Application
