$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec/its'
require 'rspec/collection_matchers'
require 'pry'
require 'rasp'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

