# encoding: utf-8
require "./database"
require "digest/sha1"
require "json"

#
# Setting
#
use Rack::Session::Cookie, secret: 'toystoystoys'
use Rack::Flash
enable :method_override

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def login?
    return session[:auth] ? true : false
  end
end

#
# CONTROLLER
#
before do
  @flash = flash[:error]
end

get '/' do
  redirect('/login') unless login?

  @colors = Color.all
  @htmltemplates = HtmlTemplate.all
  @texttemplates = TextTemplate.all

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
      redirect "/"
    else
      raise "Password incorrect."
    end
  rescue => e
    puts $!
    flash[:error] = e.message
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
  unless @user.save
    @user.errors.messages.each do |index, message|
      flash[:error] = "#{index.to_s} #{message.join(',')}"
    end
  end
  redirect '/user'
end

put '/user/:id' do
  @user = User.find(params[:id])
  @user.username = paarams[:username] if @user.username != params[:username]
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
  @htmltemplate = HtmlTemplate.find(params[:id])
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
      flash[:error] = "#{index.to_s} #{message.join(',')}"
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
  @color = Color.find(params[:id])
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
  redirect '/color' if Color.update(params[:id], name:params[:name], title:params[:title], frame:params[:frame],
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
  @texttemplate = TextTemplate.find(params[:id])
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
    c.header = h params[:header]
    c.footer = h params[:footer]
    c.col1_title = params[:col1_title]
    c.col2_title = params[:col2_title]
    c.col3_title = params[:col3_title]
    c.col4_title = params[:col4_title]
    c.col5_title = params[:col5_title]
    c.col1_text = h params[:col1_text]
    c.col2_text = h params[:col2_text]
    c.col3_text = h params[:col3_text]
    c.col4_text = h params[:col4_text]
    c.col5_text = h params[:col5_text]
    c.user_id = params[:user]
  end
  @texttemplate.save
  redirect '/text_template'
end

put '/text_template/:id' do
  redirect '/text_template' if TextTemplate.update(params[:id],
                                params[:name], params[:header], params[:footer],
                                params[:col1_title], params[:col2_title], params[:col3_title],
                                params[:col4_title], params[:col5_title],
                                params[:col1_text], params[:col2_text], params[:col3_text],
                                params[:col4_text], params[:col5_text],
                                params[:user]
                              )
end

delete '/text_template' do
  redirect '/text_template' if TextTemplate.destroy_all(id:params[:id_collection])
end
