#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/date'

class DateTestCase < RUNIT::TestCase
  
  def test
    assert_equal 28, Date.days_in_month(2010, 2)
    assert_equal 31, Date.days_in_month(2010, 1)
    assert_equal 29, Date.days_in_month(2008, 2)
    assert_equal 30, Date.days_in_month(2007, 6)
    assert_equal 31, Date.days_in_month(2010, 12)
  end

end
