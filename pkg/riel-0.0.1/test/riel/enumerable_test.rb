#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'rubyunit'
require 'riel/enumerable'

class EnumerableTestCase < RUNIT::TestCase

  def test_collect_with_index
    assert_equals([ 0, 5, 12, 21, 32 ],     (4   ..   8).collect_with_index { |val, idx| val * idx })
    assert_equals([ "", "b", "cc", "ddd" ], ('a' .. 'd').collect_with_index { |str, idx| str * idx })
  end
  
  def test_select_with_index
    assert_equals([ 5, 6, 7, 8 ], (4 .. 8).select_with_index { |val, idx| val >= 5 })
    assert_equals([ 6 ],          (4 .. 8).select_with_index { |val, idx| val * idx == 12 })
    assert_equals([],             (4 .. 8).select_with_index { |val, idx| idx - val > 0  })
  end

  def test_detect_with_index
    assert_equals(5,   (4 .. 8).detect_with_index { |val, idx| val >= 5 })
    assert_equals(6,   (4 .. 8).detect_with_index { |val, idx| val * idx == 12 })
    assert_equals(nil, (4 .. 8).detect_with_index { |val, idx| idx - val > 0  })
  end

end
