#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/env'

class IOTestCase < RUNIT::TestCase

  def test_readlines
    orig = $/

    $/ = nil

    contents = IO.readlines(__FILE__)
    
    assert_not_nil contents
    assert contents.size > 0

    $/ = orig
  end

end
