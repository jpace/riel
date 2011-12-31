#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'rubyunit'
require 'riel/string'

class StringToRangeTestCase < RUNIT::TestCase

  def do_string_to_range_test(exp, str, args = Hash.new)
    String.to_ranges(str, args).each_with_index do |rg, idx|
      assert_equal exp[idx], rg
    end
  end

  def test_string_to_range
    do_string_to_range_test([          ],                                       "")
    do_string_to_range_test([  1 ..  1 ],                                       "1")
    do_string_to_range_test([  1 ..  2 ],                                       "1..2")
    do_string_to_range_test([  1 ..  1, 2 .. 2 ],                               "1,2")
    do_string_to_range_test([  1 ..  2 ],                                       "1,2",               :collapse => true)

    do_string_to_range_test([  1 ..  4 ],                                       "1-4")
    do_string_to_range_test([ -String::Infinity ..  4 ],                        "-4")
    do_string_to_range_test([ 4 .. String::Infinity ],                          "4-")

    do_string_to_range_test([ -8 ..  4 ],                                       "-4",                :min => -8)
    do_string_to_range_test([  0 ..  4 ],                                       "-4",                :min => 0)
    do_string_to_range_test([  1 ..  8 ],                                       "1-",                :min => 0, :max => 8)
    do_string_to_range_test([  1 ..  5 ],                                       "1-4,5",             :collapse => true)
    do_string_to_range_test([  1 ..  4, 5 .. 5 ],                               "1-4,5",             :collapse => false)
    do_string_to_range_test([  1 ..  4, 5 .. 5 ],                               "1-4,5")
    do_string_to_range_test([  1 ..  3, 5 .. 8 ],                               "1,2,3,5-",          :min => 0, :max => 8, :collapse => true)
    do_string_to_range_test([  1 ..  1, 2 .. 2, 3 .. 3, 5 .. 8 ],               "1,2,3,5-",          :min => 0, :max => 8)
    do_string_to_range_test([  1 ..  3, 5 .. 6 ],                               "1-3,5,6",           :min => 0, :max => 8, :collapse => true)
    do_string_to_range_test([  1 ..  3, 5 .. 5, 6 .. 6 ],                       "1-3,5,6",           :min => 0, :max => 8)
    do_string_to_range_test([  1 ..  3, 5 .. 6, 10 .. 12 ],                     "1-3,5-6,10,11,12,", :collapse => true)
    do_string_to_range_test([  1 ..  3, 5 .. 6, 10 .. 10, 11 .. 11, 12 .. 12 ], "1-3,5-6,10,11,12,")
    
    do_string_to_range_test([ ],                                                "abc")
  end

  def test_num
    assert_equals(1,   "1".num)
    assert_equals(nil, "one".num)
  end

  def test_minus
    assert_equals("foo", "food" - "d")
    assert_equals("fd",  "food" - %r{o+})
  end

  def test_highlight
    assert_equals("...\e[34mthis\e[0m... is blue", "...this... is blue".highlight(%r{this}, "blue"))
    assert_equals("...\e[34m\e[42mthis\e[0m... is blue", "...this... is blue".highlight(%r{this}, "blue on green"))
  end

end
