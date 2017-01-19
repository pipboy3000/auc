require File.expand_path('../test_helper', __FILE__)

class LoginTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  test 'Login fail' do
    post '/login', username: 'aaaaaaaa', password: 'aaaaaaaa'
    follow_redirect!
    assert_equal 'http://example.org/login', last_request.url
  end

  test 'Login success' do
    post '/login', username: 'admin', password: 'password'
    assert session[:auth] == 1
    assert session[:username] == 'admin'
    assert session[:is_admin] == true
    follow_redirect!
    assert_equal 'http://example.org/', last_request.url
  end
end
