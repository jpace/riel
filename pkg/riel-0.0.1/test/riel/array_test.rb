#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/array'

class ArrayTestCase < RUNIT::TestCase

  def test_to_s
    a = %w{ this is a test }
    assert_equal "[ this, is, a, test ]", a.to_s
  end

  def test_rand
    a = %w{ this is a test }
    10.times do
      r = a.rand
      assert_not_nil r
      assert a.include?(r)
    end
  end
end
