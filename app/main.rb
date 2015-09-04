# encoding: utf-8

require File.join(File.dirname(__FILE__), '/database')
require "digest/sha1"
require "json"
require "sinatra/reloader" if development?

#
# Setting
#
enable :method_override
set :root, File.dirname(__FILE__)
set :haml, :hyphenate_data_attrs => false

configure :development, :test, :production do
  enable :logging
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def login?(auth)
    return auth ? true : false
  end

  def nl2br(text)
    text.gsub(/\r\n|\n/, "<br>")
  end

  def br2nl(text)
    text.gsub(/<br>/, "\r\n")
  end

  def texttemplate_title(index)
    defaults = {1 => "商品詳細", 2 => "発送詳細", 3 => "支払詳細", 4 => "注意事項", 5 => "店舗詳細・古物取扱証明に関して"}
    defaults[index]
  end
end

#
# CONTROLLER
#
before do
  if ENV['GATEWAY']
    halt 403 unless request.referrer

    unless request.referrer.match(/#{ENV['GATEWAY']}|#{request.host}/)
      halt 403
    end
  end
end

before %r{/(?!login|logout)} do
  redirect '/login' unless login?(session["auth"])
end

get '/' do
  @colors = Color.all
  @htmltemplates = HtmlTemplate.all
  @texttemplates = TextTemplate.all
  @shops = Shop.all

  haml :index
end

['/login', '/logout'].each do |path|
  get path do
    session.clear
    haml :login, layout:false
  end
end

post '/login' do
  begin
    @user = User.where(username:params[:username]).first
    if @user.auth(params[:password])
      session[:auth] = @user.id
      session[:username] = @user.username
      session[:is_admin] = @user.is_admin
      redirect "/"
    else
      raise "Password incorrect."
    end
  rescue
    puts $!
    puts "ユーザー名かパスワードが間違っています"
    redirect "/login"
  end
end

get '/user' do
  @users = User.all
  haml :user
end

get '/user/:id' do
  @user = User.find(params[:id])
  haml :user_show
end

post '/user' do
  @user = User.new
  @user.username = params[:username]
  @user.salt = Time.now.to_s
  @user.crypted_password = @user.hexdigest(params[:password], @user.salt)
  @user.is_admin = params[:is_admin] == "true" ? true : false
  unless @user.save
    @user.errors.messages.each do |index, message|
      puts "#{index.to_s} #{message.join(',')}"
    end
  end
  redirect '/user'
end

put '/user/:id' do
  @user = User.find(params[:id])
  @user.username = paarams[:username] if @user.username != params[:username]
  @user.is_admin = params[:is_admin] == "true" ? true : false
  unless params[:password].empty?
    @user.salt = Time.now.to_s
    @user.crypted_password = @user.hexdigest(params[:password], @user.salt)
  end

  redirect '/user' if @user.save
end

delete '/user' do
  redirect '/user' if User.destroy_all(id:params[:id_collection])
end

get '/html_template' do
  @htmltemplates = HtmlTemplate.all
  haml :htmltemplate
end

get '/html_template/:id/?:format?' do
  @htmltemplate = HtmlTemplate.find_by id: params[:id]
  if params[:format] === "json"
    content_type :json
    @htmltemplate.to_json
  else
    haml :htmltemplate_show
  end
end

post '/html_template' do
  @htmltemplate = HtmlTemplate.new
  @htmltemplate.name = params[:name]
  @htmltemplate.contents = params[:contents]
  unless @htmltemplate.save
    @htmltemplate.errors.messages.each do |index, message|
      puts "#{index.to_s} #{message.join(',')}"
    end
  end
  redirect '/html_template'
end

put '/html_template/:id' do
  redirect '/html_template' if HtmlTemplate.update(params[:id], name:params[:name], contents:params[:contents])
end

delete '/html_template' do
  redirect '/html_template' if HtmlTemplate.destroy_all(id:params[:id_collection])
end

get '/color' do
  @colors = Color.all
  haml :color
end

get '/color/:id/?:format?' do
  @color = Color.find_by id: params[:id]
  if params[:format] === "json"
    content_type :json
    @color.to_json
  else
    haml :color_show
  end
end

post '/color' do
  @color = Color.new do |c|
    c.name = params[:name]
    c.title = params[:title]
    c.frame = params[:frame]
    c.text1 = params[:text1]
    c.text2 = params[:text2]
    c.bg1 = params[:bg1]
    c.bg2 = params[:bg2]
  end
  @color.save
  redirect '/color'
end

put '/color/:id' do
  redirect '/color' if Color.update(params[:id], name:params[:name], title:params[:title],
                                                 frame:params[:frame],
                                                 text1:params[:text1], text2:params[:text2],
                                                 bg1:params[:bg1], bg2:params[:bg2])
end

delete '/color' do
  redirect '/color' if Color.destroy_all(id:params[:id_collection])
end


get '/text_template' do
  @texttemplates = TextTemplate.all
  haml :texttemplate
end

get '/text_template/:id/?:format?' do
  @texttemplate = TextTemplate.find_by id: params[:id]
  (1..5).each do |i|
    @texttemplate["col#{i}_text"] = nl2br(@texttemplate["col#{i}_text"])
  end

  if params[:format] === "json"
    content_type :json
    @texttemplate.to_json
  else
    haml :texttemplate_show
  end
end

post '/text_template' do
  @texttemplate = TextTemplate.new do |c|
    c.name = params[:name]
    c.header = params[:header]
    c.footer = params[:footer]
    (1..5).each do |i|
      c["col#{i}_title".to_sym] = params["col#{i}_title".to_sym]
      c["col#{i}_text".to_sym] = params["col#{i}_text".to_sym]
    end
  end
  @texttemplate.save
  redirect '/text_template'
end

put '/text_template/:id' do
  data = {name: params[:name], header: params[:header], footer: params[:footer]}
  (1..5).each do |i|
    data["col#{i}_title".to_sym] = params["col#{i}_title".to_sym]
    data["col#{i}_text".to_sym] = params["col#{i}_text".to_sym]
  end
  redirect '/text_template' if TextTemplate.update(params[:id], data)
end

delete '/text_template' do
  redirect '/text_template' if TextTemplate.destroy_all(id:params[:id_collection])
end

get '/shop' do
  @shops = Shop.all
  haml :shop
end

get '/shop/:id/?:format?' do
  @shop = Shop.find_by id: params[:id]
  if params[:format] === "json"
    content_type :json
    @shop.to_json
  else
    haml :shop_show
  end
end

post '/shop' do
  @shop = Shop.new do |c|
    c.name = params[:name]
    (1..9).each do |i|
      c["contents#{i}".to_sym] = params["contents#{i}".to_sym]
    end

  end
  @shop.save
  redirect '/shop'
end

put '/shop/:id' do
  data = {name: params[:name]}
  (1..9).each do |i|
    data["contents#{i}".to_sym] = params["contents#{i}".to_sym]
  end
  redirect '/shop' if Shop.update(params[:id], data)
end

delete '/shop' do
  redirect '/shop' if Shop.destroy_all(id:params[:id_collection])
end
