#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/setdiff'

class SetDiffTestCase < RUNIT::TestCase

  def do_test(a, b, expected)
    sd = SetDiff.new(a, b)

    assert_equal(expected, sd.diff_type)
  end

  def test_all
    do_test(%w{ one two three }, %w{ two one three },  :identical)
    do_test(%w{ one two },       %w{ two one three },  :b_contains_a)
    do_test(%w{ one two three }, %w{ two },            :a_contains_b)
    do_test(%w{ one two three }, %w{ four five six },  :no_common)
    do_test(%w{ one two three }, %w{ },                :no_common)
    do_test(%w{ },               %w{ one two three },  :no_common)
    do_test(%w{ },               %w{ },                :no_common)
    do_test(%w{ one two three},  %w{ two three four }, :common)
  end
    
end
