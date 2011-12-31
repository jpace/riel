#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/matchdata'


class MatchDataTestCase < RUNIT::TestCase

  def test_inspect
    md = %r{(foo)(.*)(bar)}.match("footloose sidebar")
    assert_equals "[\"footloose sidebar\", \"foo\", \"tloose side\", \"bar\"]", md.inspect
  end

end
