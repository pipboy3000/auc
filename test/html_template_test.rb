require File.expand_path('../helper', __FILE__)

class HtmlTemplateTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  def setup
    with_auth_session
  end

  test 'access /html_template list html_templates' do
    get '/html_template'
    assert last_response.body.include? 'shop 1 html template'
  end

  test 'specific html_template find' do
    get '/html_template/1'
    assert last_response.body.include? 'shop 1 html template'
  end

  test 'redirect to /html_template when entry not found' do
    get '/html_template/100000'
    follow_redirect!
    assert_equal 'http://example.org/html_template', last_request.url
  end

  test 'add html_template' do
    params = {
      name: 'new html_template', contents: 'This is new html_template'
    }
    post '/html_template', params
    follow_redirect!
    assert last_response.body.include? 'new html_template'
    delete '/html_template', id_collection: [2]
  end

  test 'fail add html_template when same name ' do
    params = {
      name: 'shop 1 html template', contents: ''
    }
    post '/html_template', params
    assert last_response.body.include? 'already been taken'
  end

  test 'update html_template' do
    params = {
      name: 'updated_html_template', contents: 'This html_template update'
    }
    put '/html_template/100', params
    follow_redirect!
    assert last_response.body.include? 'updated_html_template'
  end

  test 'delete html_template' do
    params = { id_collection: %w(998 999) }
    delete '/html_template', params
    follow_redirect!
    assert !(last_response.body.include? 'html_template 998')
    assert !(last_response.body.include? 'html_template 999')
  end
end
