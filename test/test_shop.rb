require File.expand_path('../test_helper', __FILE__)

class ShopTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  def setup
    with_auth_session
  end

  test 'shop name should be uniq' do
    s = Shop.new
    s.name = 'Shop 1'
    s.contents1 = 'aa'
    assert !s.valid?
  end

  test 'shop name should not empty' do
    s = Shop.new
    s.name = ''
    s.contents1 = 'aa'
    assert !s.valid?
  end

  test 'shop contents1 should not empty' do
    s = Shop.new
    s.name = 'Shop test'
    s.contents1 = ''
    assert !s.valid?
  end

  test 'access /shop list shops' do
    get '/shop'
    assert last_response.body.include? 'Shop 1'
  end

  test 'specific shop find' do
    get '/shop/1'
    assert last_response.body.include? 'Shop 1'
  end

  test 'redirect to /shop when entry not found' do
    get '/shop/100000'
    follow_redirect!
    assert_equal 'http://example.org/shop', last_request.url
  end

  test 'add shop' do
    params = {
      name: 'new shop',
      contents1: 'This is new shop',
      contents2: 'Tel: 000-0000-0000'
    }
    post '/shop', params
    follow_redirect!
    assert last_response.body.include? 'new shop'
    delete '/shop', id_collection: [2]
  end

  test 'fail add shop when same name ' do
    params = {
      name: 'Shop 1',
      contents1: 'Awesome shop no 1',
      contents2: 'Tel: 000-0000-0000'
    }
    post '/shop', params
    assert last_response.body.include? 'already been taken'
  end

  test 'update shop' do
    params = {
      name: 'updated_shop',
      contents1: 'This shop update',
      contents2: 'Tel: 000-0000-0000'
    }
    put '/shop/100', params
    follow_redirect!
    assert last_response.body.include? 'updated_shop'
  end

  test 'delete shop' do
    params = { id_collection: %w(998 999) }
    delete '/shop', params
    follow_redirect!
    assert !(last_response.body.include? 'shop 998')
    assert !(last_response.body.include? 'shop 999')
  end
end
