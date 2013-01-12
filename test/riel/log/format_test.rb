#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'test/unit'
require 'stringio'
require 'riel/log/format'
require 'riel/log/loggable'

module RIEL
  class FormatTestCase < Test::Unit::TestCase
    include RIEL::Loggable

    def run_trim_left_test expected, length, str = "something"
      trimmed = Format.new.trim_left(str, length)
      assert_equal expected, trimmed
    end

    def test_trim_left_short_positive_number
      run_trim_left_test "some", 4
    end

    def test_trim_left_long
      run_trim_left_test "something", 10
    end

    def test_trim_left_short_negative_number
      run_trim_left_test "some", -4
    end

    def run_trim_right_test expected, length, str = "something"
      trimmed = Format.new.trim_right(str, length)
      assert_equal expected, trimmed
    end

    def test_trim_right_short_positive_number
      run_trim_right_test "  ...", 5
    end

    def test_trim_right_long
      run_trim_right_test "something", 10
    end

    def test_trim_right_short_negative_number
      run_trim_right_test "  ...", -5
    end
  end
end
