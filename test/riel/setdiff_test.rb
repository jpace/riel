#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/setdiff'

class SetDiffTestCase < Test::Unit::TestCase
  def run_test a, b, expected
    sd = SetDiff.new a, b
    assert_equal expected, sd.diff_type
  end

  def test_all
    run_test %w{ one two three }, %w{ two one three },  :identical
    run_test %w{ one two },       %w{ two one three },  :b_contains_a
    run_test %w{ one two three }, %w{ two },            :a_contains_b
    run_test %w{ one two three }, %w{ four five six },  :no_common
    run_test %w{ one two three }, %w{ },                :no_common
    run_test %w{ },               %w{ one two three },  :no_common
    run_test %w{ },               %w{ },                :no_common
    run_test %w{ one two three},  %w{ two three four }, :common
  end
end
