require File.expand_path('../helper', __FILE__)

class ColorTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  def setup
    with_auth_session
  end

  test 'access /color list colors' do
    get '/color'
    assert last_response.body.include? 'default'
  end

  test 'specific color find' do
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
    delete '/color', id_collection: [2]
  end

  test 'fail add color that color code is too long' do
    params = {
      name: 'failable color', title: '#3333333', frame: '#efefefef',
      text1: '#3333333', text2: '#3333333',
      bg1: '#eeeeeee', bg2: '#eeeeee'
    }
    post '/color', params
    assert last_response.body.include? 'is too long'
    delete '/color', id_collection: [2]
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
