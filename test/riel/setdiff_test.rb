#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/setdiff'

class SetDiffTestCase < Test::Unit::TestCase
  def assert_diff_type a, b, expected
    sd = SetDiff.new a, b
    assert_equal expected, sd.diff_type
  end

  def test_identical_same_order
    assert_diff_type %w{ one two three }, %w{ one two three },  :identical
  end

  def test_identical_different_order
    assert_diff_type %w{ one two three }, %w{ two one three },  :identical
  end

  def test_common
    assert_diff_type %w{ one two three }, %w{ one dos three },  :common
  end

  def test_b_contains_a
    assert_diff_type %w{ one two }, %w{ two one three },  :b_contains_a
  end

  def test_a_contains_b
    assert_diff_type %w{ one two three }, %w{ one two },  :a_contains_b
  end

  def test_no_common_nonempty
    assert_diff_type %w{ one two three }, %w{ four five six },  :no_common
  end

  def test_no_common_empty
    assert_diff_type %w{ one two three }, %w{ },  :no_common
  end

  def test_no_common_both_empty
    assert_diff_type %w{ }, %w{ }, :no_common
  end
end
