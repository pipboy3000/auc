# encoding: utf-8

require File.join(File.dirname(__FILE__), '/database')
require 'digest/sha1'
require 'json'
require 'sinatra/reloader' if settings.development?

#
# Setting
#
enable :method_override
set :root, File.dirname(__FILE__)
set :haml, hyphenate_data_attrs: false

configure :development, :test, :production do
  enable :logging
end

#
# Helpers
#
helpers do
  include Rack::Utils

  def login?(auth)
    auth ? true : false
  end

  def nl2br(text)
    text.gsub(/\r\n|\n/, '<br>') unless text.nil?
  end

  def br2nl(text)
    text.gsub(/<br>/, "\r\n") unless text.nil?
  end

  def texttemplate_title(index)
    defaults = {
      1 => '商品詳細',
      2 => '発送詳細',
      3 => '支払詳細',
      4 => '注意事項',
      5 => '店舗詳細・古物取扱証明に関して'
    }
    defaults[index]
  end

  def error_message(obj)
    obj.errors.messages.map { |i, m| "#{i} #{m.join(', ')}" }.join(' ')
  end
end

#
# Controller
#
before do
  if ENV['GATEWAY']
    unless request.referrer ||
           request.referrer.match(/#{ENV['GATEWAY']}|#{request.host}/)
      halt 403
    end
  end
end

before %r{/(?!login|logout|welcome)} do
  redirect '/login' unless login?(session['auth'])
end

error do
  env['sinatra.error'].message
end

get '/' do
  @colors = Color.all
  @htmltemplates = HtmlTemplate.all
  @texttemplates = TextTemplate.all
  @shops = Shop.all

  haml :index
end

get '/welcome' do
  haml :welcome, layout: false
end

['/login', '/logout'].each do |path|
  get path do
    session.clear
    haml :login, layout: false
  end
end

post '/login' do
  @user = User.where(username: params[:username]).first
  redirect '/login' unless @user
  redirect '/login' unless @user.auth(params[:password])

  session[:auth] = @user.id
  session[:username] = @user.username
  session[:is_admin] = @user.is_admin
  redirect '/'
end

get '/user' do
  @users = User.all
  haml :user
end

get '/user/:id' do
  begin
    @user = User.find(params[:id])
  rescue
    redirect '/user'
  end

  haml :user_show
end

post '/user' do
  redirect '/user' if params[:password].empty?

  @user = User.new
  @user.username = params[:username]
  @user.salt = Time.now.to_s
  @user.crypted_password = User.hexdigest(params[:password], @user.salt)
  @user.is_admin = params[:is_admin] == 'true' ? true : false
  halt 400, error_message(@user) unless @user.save
  redirect '/user'
end

put '/user/:id' do
  @user = User.find(params[:id])
  @user.username = params[:username] if @user.username != params[:username]
  @user.is_admin = params[:is_admin] == 'true' ? true : false
  unless params[:password].empty?
    @user.salt = Time.now.to_s
    @user.crypted_password = User.hexdigest(params[:password], @user.salt)
  end
  halt 400, error_message(@user) unless @user.save
  redirect '/user'
end

delete '/user' do
  redirect '/user' if User.destroy_all(id: params[:id_collection])
end

get '/html_template' do
  @htmltemplates = HtmlTemplate.all
  haml :htmltemplate
end

get '/html_template/:id/?:format?' do
  @htmltemplate = HtmlTemplate.find_by id: params[:id]
  redirect '/html_template' unless @htmltemplate
  if params[:format] == 'json'
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
  halt 400, error_message(@htmltemplate) unless @htmltemplate.save
  redirect '/html_template'
end

put '/html_template/:id' do
  @htmltemplate = HtmlTemplate.find(params[:id])
  if @htmltemplate.update(name: params[:name], contents: params[:contents])
    redirect '/html_template'
  else
    halt 400, error_message(@htmltemplate)
  end
end

delete '/html_template' do
  if HtmlTemplate.destroy_all(id: params[:id_collection])
    redirect '/html_template'
  else
    halt 400, error_message(@htmltemplate)
  end
end

get '/color' do
  @colors = Color.all
  haml :color
end

get '/color/:id/?:format?' do
  @color = Color.find_by id: params[:id]
  redirect '/color' unless @color

  if params[:format] == 'json'
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
  halt 400, error_message(@color) unless @color.save
  redirect '/color'
end

put '/color/:id' do
  @color = Color.find(params[:id])
  if @color.update(name: params[:name],
                   title: params[:title],
                   frame: params[:frame],
                   text1: params[:text1],
                   text2: params[:text2],
                   bg1: params[:bg1],
                   bg2: params[:bg2])
    redirect '/color'
  else
    halt 400, error_message(@color)
  end
end

delete '/color' do
  if Color.destroy_all(id: params[:id_collection])
    redirect '/color'
  else
    halt 400, error_message(@color.errors.message)
  end
end

get '/text_template' do
  @texttemplates = TextTemplate.all
  haml :texttemplate
end

get '/text_template/:id/?:format?' do
  @texttemplate = TextTemplate.find_by id: params[:id]

  redirect '/text_template' unless @texttemplate

  (1..5).each do |i|
    @texttemplate["col#{i}_text"] = nl2br(@texttemplate["col#{i}_text"])
  end

  if params[:format] == 'json'
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
  halt 400, error_message(@texttemplate) unless @texttemplate.save
  redirect '/text_template'
end

put '/text_template/:id' do
  @text_template = TextTemplate.find(params[:id])
  data = {
    name: params[:name],
    header: params[:header],
    footer: params[:footer]
  }
  (1..5).each do |i|
    title_key = "col#{i}_title".to_sym
    text_key = "col#{i}_text".to_sym
    data[title_key] = params[title_key]
    data[text_key] = params[text_key]
  end
  halt 400, error_message(@text_template) unless @text_template.update(data)
  redirect '/text_template'
end

delete '/text_template' do
  if TextTemplate.destroy_all(id: params[:id_collection])
    redirect '/text_template'
  end
end

get '/shop' do
  @shops = Shop.all
  haml :shop
end

get '/shop/:id/?:format?' do
  @shop = Shop.find_by id: params[:id]
  redirect '/shop' unless @shop
  if params[:format] == 'json'
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
  halt 400, error_message(@shop) unless @shop.save
  redirect '/shop'
end

put '/shop/:id' do
  @shop = Shop.find(params[:id])
  data = { name: params[:name] }
  (1..9).each do |i|
    data["contents#{i}".to_sym] = params["contents#{i}".to_sym]
  end
  halt 400, error_message(@shop) unless @shop.update(data)
  redirect '/shop'
end

delete '/shop' do
  redirect '/shop' if Shop.destroy_all(id: params[:id_collection])
end
