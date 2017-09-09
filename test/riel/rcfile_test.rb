#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/rcfile'
require 'paramesan'

class RCFileTestCase < Test::Unit::TestCase
  include Paramesan

  def self.build_params
    kv = [ "k", "v" ]
    kvary = [ kv ]

    Array.new.tap do |params|
      params << [ Array.new, Array.new ]
      params << [ Array.new, [ "" ] ]
      [ "k:v", "k: v", "k :v", "k=v", "k= v", "k =v", "k:v ", " k:v" ].each do |line|
        params << [ kvary, [ line ] ]
      end
      params << [ kvary, [ "", "k:v" ] ]
      params << [ kvary, [ "# comment", "k:v" ] ]
      params << [ kvary, [ "  # comment", "k:v" ] ]
      params << [ Array.new, [ "k:#v" ] ]
      params << [ [ [ "k", "v" ] ], [ "k:v#x" ] ]
      params << [ [ [ "k", "v" ], [ "k2", "v2" ] ], [ "k:v", "k2:v2" ] ]
    end
  end

  param_test build_params do |exp, lines|
    rc = RCFile.new lines: lines
    assert_equal exp, rc.settings, "lines: #{lines}"
  end

  def test_block
    called = Array.new
    RCFile.new(lines: [ "k:v" ]) do |key, value|
      called << [ key, value ]
    end
    assert_equal [ [ "k", "v" ] ], called
  end
end
