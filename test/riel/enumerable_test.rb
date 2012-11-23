#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/enumerable'

class EnumerableTestCase < Test::Unit::TestCase
  def test_collect_with_index
    assert_equal [ 0, 5, 12, 21, 32 ],     (4   ..   8).collect_with_index { |val, idx| val * idx }
    assert_equal [ "", "b", "cc", "ddd" ], ('a' .. 'd').collect_with_index { |str, idx| str * idx }
  end
  
  def test_select_with_index
    assert_equal [ 5, 6, 7, 8 ], (4 .. 8).select_with_index { |val, idx| val >= 5 }
    assert_equal [ 6 ],          (4 .. 8).select_with_index { |val, idx| val * idx == 12 }
    assert_equal [],             (4 .. 8).select_with_index { |val, idx| idx - val > 0  }
  end

  def test_detect_with_index
    assert_equal 5,   (4 .. 8).detect_with_index { |val, idx| val >= 5 }
    assert_equal 6,   (4 .. 8).detect_with_index { |val, idx| val * idx == 12 }
    assert_equal nil, (4 .. 8).detect_with_index { |val, idx| idx - val > 0  }
  end
end
