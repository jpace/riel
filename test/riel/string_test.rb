#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'test/unit'
require 'riel/string'

class StringToRangeTestCase < Test::Unit::TestCase
  def run_string_to_range_test exp, str, args = Hash.new
    String.to_ranges(str, args).each_with_index do |rg, idx|
      assert_equal exp[idx], rg
    end

    str.to_ranges(args).each_with_index do |rg, idx|
      assert_equal exp[idx], rg
    end
  end

  def test_string_to_range
    run_string_to_range_test([          ],                                       "")
    run_string_to_range_test([  1 ..  1 ],                                       "1")
    run_string_to_range_test([  1 ..  2 ],                                       "1..2")
    run_string_to_range_test([  1 ..  1, 2 .. 2 ],                               "1,2")
    run_string_to_range_test([  1 ..  2 ],                                       "1,2",               :collapse => true)

    run_string_to_range_test([  1 ..  4 ],                                       "1-4")
    run_string_to_range_test([ -String::Infinity ..  4 ],                        "-4")
    run_string_to_range_test([  4 .. String::Infinity  ],                        "4-")

    run_string_to_range_test([ -8 ..  4 ],                                       "-4",                :min => -8)
    run_string_to_range_test([  0 ..  4 ],                                       "-4",                :min => 0)
    run_string_to_range_test([  1 ..  8 ],                                       "1-",                :min => 0, :max => 8)
    run_string_to_range_test([  1 ..  5 ],                                       "1-4,5",             :collapse => true)
    run_string_to_range_test([  1 ..  4, 5 .. 5 ],                               "1-4,5",             :collapse => false)
    run_string_to_range_test([  1 ..  4, 5 .. 5 ],                               "1-4,5")
    run_string_to_range_test([  1 ..  3, 5 .. 8 ],                               "1,2,3,5-",          :min => 0, :max => 8, :collapse => true)
    run_string_to_range_test([  1 ..  1, 2 .. 2, 3 .. 3, 5 .. 8 ],               "1,2,3,5-",          :min => 0, :max => 8)
    run_string_to_range_test([  1 ..  3, 5 .. 6 ],                               "1-3,5,6",           :min => 0, :max => 8, :collapse => true)
    run_string_to_range_test([  1 ..  3, 5 .. 5, 6 .. 6 ],                       "1-3,5,6",           :min => 0, :max => 8)
    run_string_to_range_test([  1 ..  3, 5 .. 6, 10 .. 12 ],                     "1-3,5-6,10,11,12,", :collapse => true)
    run_string_to_range_test([  1 ..  3, 5 .. 6, 10 .. 10, 11 .. 11, 12 .. 12 ], "1-3,5-6,10,11,12,")
    
    run_string_to_range_test([ ],                                                "abc")
  end

  def test_num
    assert_equal 1,   "1".num
    assert_equal nil, "one".num
  end

  def test_minus
    assert_equal "foo", "food" - "d"
    assert_equal "fd",  "food" - %r{o+}
  end
end
