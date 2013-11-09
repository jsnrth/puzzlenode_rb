require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'

class Minitest::Spec
  class << self
    alias_method :test, :it
  end
end
