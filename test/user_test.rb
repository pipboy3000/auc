require File.expand_path('../helper', __FILE__)

class UserTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  test "access /user list users" do
    get '/user'
    assert last_response.body.include? "admin"
  end

  test "specific user find" do
    get '/user/1'
    assert last_response.body.include? "admin"
  end

  test "redirect to /user when user not found" do
    get '/user/100000'
    follow_redirect!
    assert_equal "http://example.org/user", last_request.url
  end

  test "add user" do
    post '/user', username: "user2", password: "password", is_admin: false
    follow_redirect!
    assert last_response.body.include? "user1"
    delete '/user', id_collection: [3]
  end

  test "fail add user, password missing" do
    post '/user', username: "user3", password: "", is_admin: false
    follow_redirect!
    assert !(last_response.body.include? "user3")
  end

  test "fail add user, same username " do
    post '/user', username: "user1", password: "user1", is_admin: false
    assert last_response.body.include? "already been taken"
  end

  test "update username" do
    put '/user/100', username: "user50", password: "", is_admin: false
    follow_redirect!
    assert last_response.body.include? "user50"
  end
  
  test "delete user" do
    delete '/user', id_collection: ["998", "999"]
    follow_redirect!
    assert !(last_response.body.include? "user998")
    assert !(last_response.body.include? "user999")
  end
end
