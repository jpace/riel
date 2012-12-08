#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'stringio'

module Text
  class PaletteTest < Test::Unit::TestCase
    def assert_print expected, meth
      ap = cls.instance
      sio = StringIO.new
      origstdout = $stdout
      $stdout = sio
      ap.send meth
      sio.flush
      $stdout = origstdout
      str = sio.string
      # puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      # puts str
      # puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      assert_equal expected.join(''), str
    end

    def test_nothing
    end
  end
end
