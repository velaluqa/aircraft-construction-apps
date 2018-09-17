require 'bundler'

Bundler.require

require './app'

map '/' do
  run App
end
