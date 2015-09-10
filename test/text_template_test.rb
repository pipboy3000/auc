require File.expand_path('../helper', __FILE__)

class TextTemplateTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper::Methods

  class << self
    include TestHelper::PrepareDatabase
  end

  def setup
    with_auth_session
  end

  test 'access /text_template list shops' do
    get '/text_template'
    assert last_response.body.include? 'shop 1 text template'
  end

  test 'specific text template find' do
    get '/text_template/1'
    assert last_response.body.include? 'shop 1 text template'
  end

  test 'redirect to /text_template when entry not found' do
    get '/text_template/100000'
    follow_redirect!
    assert_equal 'http://example.org/text_template', last_request.url
  end

  test 'add text template' do
    params = { name: 'new shop' }
    post '/text_template', params
    follow_redirect!
    assert last_response.body.include? 'new shop'
    delete '/text_template', id_collection: [2]
  end

  test 'fail add shop when same name ' do
    params = { name: 'shop 1 text template' }
    post '/text_template', params
    assert last_response.body.include? 'already been taken'
  end

  test 'update text template' do
    params = {
      name: 'update shop', header: '', footer: '',
      col1_title: '', col1_text: '',
      col2_title: '', col2_text: '',
      col3_title: '', col3_text: '',
      col4_title: '', col4_text: '',
      col5_title: '', col5_text: ''
    }
    put '/text_template/100', params
    follow_redirect!
    assert last_response.body.include? 'update shop'
  end

  test 'delete shop' do
    params = { id_collection: %w(998 999) }
    delete '/text_template', params
    follow_redirect!
    assert !(last_response.body.include? 'shop 998')
    assert !(last_response.body.include? 'shop 999')
  end
end
