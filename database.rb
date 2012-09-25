# encoding: utf-8

require "rubygems"
require "bundler"
Bundler.require

configure :development do
  set :database, 'sqlite:///development.db'
end

configure :production do
  set :database, DATABASE_URL
end

class User < ActiveRecord::Base
  has_many :text_templates
  validates :username, presence:true, uniqueness:true

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
  belongs_to :user
  validates :name, presence:true, uniqueness:true
end

class HtmlTemplate < ActiveRecord::Base
  validates :name, presence:true, uniqueness:true
  validates :contents, presence:true
end
