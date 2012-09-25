require "sinatra"
require "sinatra/activerecord"
require "sinatra/activerecord/rake"
require "./web"
require "./database"

task :add_user  => ["add_slave", "add_admin"]

task :add_slave do
  @slave = User.new
  @slave.username = "toysking"
  @slave.salt = Time.now.to_s
  @slave.crypted_password = @slave.hexdigest("hjkl0526", @slave.salt)
  @slave.is_admin = false
  @slave.save
end

task :add_admin do
  @admin = User.new
  @admin.username = "master"
  @admin.salt = Time.now.to_s
  @admin.crypted_password = @admin.hexdigest("2381", @admin.salt)
  @admin.is_admin = true
  @admin.save
end


