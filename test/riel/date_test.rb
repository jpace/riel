#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/date'

class Date
  include RIEL::DateExt
end

class DateTestCase < Test::Unit::TestCase
  def run_date_test expected, year, month
    dim = Date.days_in_month(year, month)
    assert_equal expected, dim, "year: #{year}; month: #{month}"
  end

  def test_january
    run_date_test 31, 2010, 1
  end

  def test_june
    run_date_test 30, 1997, 6
  end

  def test_december
    run_date_test 31, 1967, 12
  end

  def test_february_non_leap_year
    run_date_test 28, 2010, 2
  end

  def test_february_leap_year
    run_date_test 29, 2008, 2
  end
end
