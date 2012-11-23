#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/tempfile'

class TempfileTestCase < Test::Unit::TestCase
  def test_simple
    tfname = Tempfile.open("tempfile_test") { }
    assert_not_nil tfname
  end
end
