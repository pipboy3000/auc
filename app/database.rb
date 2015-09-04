# encoding: utf-8

require "bundler"
Bundler.require
require "uri"

configure :development do
  set :database, {adapter: "sqlite3", database: "development.db"}
end

configure :test do
  set :database, {adapter: "sqlite3", database: "test.db"}
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'])
  set :database, {
    adapter:  db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    host:     db.host,
    post:     db.port,
    username: db.user,
    password: db.password,
    database: db.path[1..-1],
    encoding: 'utf-8'
  }
end

module DBHelper
  def sort_order
    if ENV["RACK_ENV"] == "production"
      default_scope { order('name COLLATE "C" ASC') }
    else
      default_scope { order("name ASC") }
    end
  end
end

class User < ActiveRecord::Base
  validates :username, presence:true, uniqueness:true
  default_scope { order("username ASC") } if ENV["RACK_ENV"] == "development"
  default_scope { order('username COLLATE "C" ASC') } if ENV["RACK_ENV"] == "production"

  include DBHelper

  def auth(row_password)
    self.crypted_password === hexdigest(row_password, self.salt) ? true : false
  end

  def hexdigest(pass, salt)
    Digest::SHA1.hexdigest("#{salt}--#{pass}")
  end
end

class Color < ActiveRecord::Base
  validates :name, presence:true, uniqueness:true
  validates :title, :frame, :text1, :text2, :bg1, :bg2, presence:true
end

class TextTemplate < ActiveRecord::Base
  validates :name, presence:true, uniqueness:true
  include DBHelper
end

class HtmlTemplate < ActiveRecord::Base
  validates :name, presence:true, uniqueness:true
  validates :contents, presence:true
  include DBHelper
end

class Shop < ActiveRecord::Base
  validates :name, presence:true, uniqueness:true
  validates :contents1, presence:true
  include DBHelper
end
