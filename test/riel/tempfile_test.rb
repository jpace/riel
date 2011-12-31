#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/tempfile'

class TempfileTestCase < RUNIT::TestCase

  def test
    tfname = Tempfile.open("tempfile_test") do |tf|
    end

    assert_not_nil tfname
  end

end
