require 'rubygems'
require 'sinatra/base'

class HelloWorld < Sinatra::Base
  get '/hello.rb' do
    'hello world!'
  end
end
run HelloWorld.new
