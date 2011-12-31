#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/io'


class IOTestCase < RUNIT::TestCase

  def xtest_readlines
    orig = $/

    $/ = nil

    contents = IO.readlines(__FILE__)
    
    assert_not_nil contents
    assert contents.size > 0

    $/ = orig
  end

  def test_writelines
    name = "/tmp/testfile_writelines." + $$.to_s
    writelines = Array.new
    writelines << "this is line one"
    writelines << "line two is this"

    puts "writelines: <<<#{writelines}>>>"
    
    IO.writelines(name, writelines)

    readlines = IO.readlines name
    assert_equal writelines.collect { |line| line + "\n" }, readlines
  end

end
