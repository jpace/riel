#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/enumerable'

class Range
  include RIEL::EnumerableExt
end

class Array
  include RIEL::EnumerableExt
end

class EnumerableTestCase < Test::Unit::TestCase
  def setup
    @range = (4 .. 8)
  end

  def as_range
    @range
  end

  def as_array
    @range.to_a
  end

  def run_collect_with_index_test enum
    assert_equal [ 0, 5, 12, 21, 32 ], enum.collect_with_index { |val, idx| val * idx }, "enum: #{enum.class}"
  end

  def test_array_collect_with_index
    run_collect_with_index_test as_array
  end
  
  def test_range_collect_with_index
    run_collect_with_index_test as_range
  end

  def run_select_with_index_multi_test enum
    assert_equal [ 5, 6, 7, 8 ], enum.select_with_index { |val, idx| val >= 5 }, "enum: #{enum.class}"
  end
  
  def run_select_with_index_single_test enum
    assert_equal [ 6 ], enum.select_with_index { |val, idx| val * idx == 12 }, "enum: #{enum.class}"
  end
  
  def run_select_with_index_none_test enum
    assert_equal [], enum.select_with_index { |val, idx| idx - val > 0  }
  end
  
  def test_array_select_with_index_multi
    run_select_with_index_multi_test as_array
  end
  
  def test_array_select_with_index_single
    run_select_with_index_single_test as_array
  end
  
  def test_array_select_with_index_none
    run_select_with_index_none_test as_array
  end
  
  def test_range_select_with_index_multi
    run_select_with_index_multi_test as_range
  end
  
  def test_range_select_with_index_single
    run_select_with_index_single_test as_range
  end
  
  def test_range_select_with_index_none
    run_select_with_index_none_test as_range
  end

  def run_detect_with_index_match_test enum
    assert_equal 5, enum.detect_with_index { |val, idx| val >= 5 }
  end

  def run_detect_with_index_no_match_test enum
    assert_equal nil, enum.detect_with_index { |val, idx| idx - val > 0 }
  end

  def test_array_detect_with_index_match
    run_detect_with_index_match_test as_array
  end

  def test_array_detect_with_index_no_match
    run_detect_with_index_no_match_test as_array
  end

  def test_range_detect_with_index_match
    run_detect_with_index_match_test as_range
  end

  def test_range_detect_with_index_no_match
    run_detect_with_index_no_match_test as_range
  end
end
