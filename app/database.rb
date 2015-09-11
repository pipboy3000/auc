# encoding: utf-8

require "bundler"
Bundler.require
require "uri"

configure :development do
  set :database, { adapter: "sqlite3", database: "development.db" }
end

configure :test do
  set :database, { adapter: "sqlite3", database: "test.db" }
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
  include DBHelper
  validates :username, presence:true,
                       uniqueness:true

  class << self
    def hexdigest(pass, salt)
      Digest::SHA1.hexdigest("#{salt}--#{pass}")
    end
  end

  def auth(raw_password)
    self.crypted_password === User.hexdigest(raw_password, self.salt) ? true : false
  end
end

class Color < ActiveRecord::Base
  include DBHelper

  hex_num = /#[0-9A-F]/i
  length = { minimum: 4, maximum: 7}

  validates :name, presence:true, uniqueness:true
  validates :title, format: { with: hex_num },
                    presence: true,
                    length: length
  validates :frame, format: { with: hex_num },
                    presence: true,
                    length: length
  validates :text1, format: { with: hex_num },
                    presence: true,
                    length: length
  validates :text2, format: { with: hex_num },
                    presence: true,
                    length: length
  validates :bg1, format: { with: hex_num },
                  presence: true,
                  length: length
  validates :bg2, format: { with: hex_num },
                  presence: true,
                  length: length
end

class TextTemplate < ActiveRecord::Base
  include DBHelper
  validates :name, presence: true,
                   uniqueness: true
end

class HtmlTemplate < ActiveRecord::Base
  include DBHelper
  validates :name, presence: true,
                   uniqueness: true
  validates :contents, presence: true
end

class Shop < ActiveRecord::Base
  include DBHelper
  validates :name, presence: true,
                   uniqueness: true
  validates :contents1, presence: true
end
