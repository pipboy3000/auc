require File.expand_path('../test_helper', __FILE__)

class ColorTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  def setup
    with_auth_session
  end

  test 'color name should not same' do
    color = Color.new
    color.name = 'default'
    color.title = 'ffffff'
    color.frame = 'ffffff'
    color.text1 = 'ffffff'
    color.text2 = 'ffffff'
    color.bg1 = 'ffffff'
    color.bg2 = 'ffffff'
    assert !color.valid?
  end

  test 'color code should start #' do
    color = Color.new
    color.name = 'test color'
    color.title = 'ffffff'
    color.frame = 'ffffff'
    color.text1 = 'ffffff'
    color.text2 = 'ffffff'
    color.bg1 = 'ffffff'
    color.bg2 = 'ffffff'
    assert !color.valid?
  end

  test 'color code should hexadecimal' do
    color = Color.new
    color.name = 'test color'
    color.title = '#xxx'
    color.frame = '#ggg'
    color.text1 = '#xxx'
    color.text2 = '#ggg'
    color.bg1 = '#zzz'
    color.bg2 = '#zzz'
    assert !color.valid?
  end

  test 'color code should not empty value' do
    color = Color.new
    color.name = 'test color'
    color.title = ''
    color.frame = ''
    color.text1 = ''
    color.text2 = ''
    color.bg1 = ''
    color.bg2 = ''
    assert !color.valid?
  end

  test 'color code allow short style' do
    color = Color.new
    color.name = 'test color'
    color.title = '#fff'
    color.frame = '#fff'
    color.text1 = '#fff'
    color.text2 = '#fff'
    color.bg1 = '#fff'
    color.bg2 = '#fff'
    assert color.valid?
  end

  test 'color code should more than 3characters' do
    color = Color.new
    color.name = 'test color'
    color.title = '#ff'
    color.frame = '#ff'
    color.text1 = '#ff'
    color.text2 = '#ff'
    color.bg1 = '#ff'
    color.bg2 = '#ff'
    assert !color.valid?
  end

  test 'color code should less than 8characters' do
    color = Color.new
    color.name = 'test color'
    color.title = '#fffffff'
    color.frame = '#fffffff'
    color.text1 = '#fffffff'
    color.text2 = '#fffffff'
    color.bg1 = '#ffffff'
    color.bg2 = '#ffffff'
    assert !color.valid?
  end

  test 'access /color should list colors' do
    get '/color'
    assert last_response.body.include? 'default'
  end

  test 'specific color can find' do
    get '/color/1'
    assert last_response.body.include? 'default'
  end

  test 'redirect to /color when entry not found' do
    get '/color/100000'
    follow_redirect!
    assert_equal 'http://example.org/color', last_request.url
  end

  test 'add color' do
    params = {
      name: 'new color', title: '#333333', frame: '#efefef',
      text1: '#333333', text2: '#333333',
      bg1: '#efefef', bg2: '#efefef'
    }
    post '/color', params
    follow_redirect!
    assert last_response.body.include? 'new color'
    delete '/color', id_collection: [2]
  end

  test 'fail add color that color code is too short' do
    params = {
      name: 'failable color', title: '#3', frame: '#e',
      text1: '#3', text2: '#3',
      bg1: '#e', bg2: '#e'
    }
    post '/color', params
    assert last_response.body.include? 'is too short'
  end

  test 'fail add color that color code is too long' do
    params = {
      name: 'failable color', title: '#3333333', frame: '#efefefef',
      text1: '#3333333', text2: '#3333333',
      bg1: '#eeeeeee', bg2: '#eeeeee'
    }
    post '/color', params
    assert last_response.body.include? 'is too long'
  end

  test 'fail add color when same name ' do
    params = {
      name: 'default', title: '#333333', frame: '#efefef',
      text1: '#333333', text2: '#333333',
      bg1: '#efefef', bg2: '#efefef'
    }
    post '/color', params
    assert last_response.body.include? 'already been taken'
  end

  test 'update color' do
    params = {
      name: 'updated_color', title: '#333333', frame: '#efefef',
      text1: '#333333', text2: '#333333',
      bg1: '#efefef', bg2: '#efefef'
    }
    put '/color/100', params
    follow_redirect!
    assert last_response.body.include? 'updated_color'
  end

  test 'delete color' do
    params = { id_collection: %w(998 999) }
    delete '/color', params
    follow_redirect!
    assert !(last_response.body.include? 'color 998')
    assert !(last_response.body.include? 'color 999')
  end
end
