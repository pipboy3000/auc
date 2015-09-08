require "sinatra"
require "sinatra/activerecord"
require "sinatra/activerecord/rake"
require File.join(File.dirname(__FILE__), "app/main")
require 'rake/testtask'

task :add_admin do
  @admin = User.new
  @admin.username = "master"
  @admin.salt = Time.now.to_s
  @admin.crypted_password = User.hexdigest("password", @admin.salt)
  @admin.is_admin = true
  @admin.save
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end
