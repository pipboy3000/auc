# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{views/.+\.(erb|haml|slim)})
  watch(%r{helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
end

guard 'rack' do
  watch('web.rb')
end

guard 'coffeescript', :input => 'views', :output => 'public'

guard 'sass', :input => 'views', :output => 'public'
