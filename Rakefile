require "sinatra"
require "sinatra/activerecord"
require "sinatra/activerecord/rake"
require File.join(File.dirname(__FILE__), "app/main")
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end
