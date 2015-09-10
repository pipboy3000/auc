ENV['RACK_ENV'] = 'test'
ENV['RAILS_ENV'] = 'test'

Encoding.default_external = 'UTF-8' if defined? Encoding

testdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(testdir) unless $LOAD_PATH.include?(testdir)

appdir = File.dirname(File.expand_path(__FILE__)) + '/../app'
$LOAD_PATH.unshift(appdir) unless $LOAD_PATH.include?(appdir)

require 'test/unit'
require 'rack/test'
require 'main'
require 'pp'

module TestHelper
  module Methods
    def session
      last_request.env['rack.session']
    end

    def app
      Sinatra::Application
    end

    def with_auth_session
      env 'rack.session', 'auth' => 1
    end
  end

  module PrepareDatabase
    def startup
      puts 'setup database'
      `rake db:create;rake db:migrate;rake db:fixtures:load`
    end

    def shutdown
      puts "\ndrop database"
      `rake db:drop; rm test.db`
    end
  end
end
