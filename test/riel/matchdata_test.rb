#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/matchdata'

class MatchDataTestCase < Test::Unit::TestCase
  def test_inspect
    md = %r{(foo)(.*)(bar)}.match("footloose sidebar")
    assert_equal "[\"footloose sidebar\", \"foo\", \"tloose side\", \"bar\"]", md.inspect
  end
end
