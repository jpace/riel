#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/env'

class EnvTestCase < RUNIT::TestCase

  def test_home_directory
    # Unix
    
    ENV["HOME"] = "/home/me"
    
    assert_equals "/home/me", Env.home_directory

    # Windows
    
    ENV["HOME"] = nil
    ENV["HOMEDRIVE"] = "c:"
    
    assert_equals "c:\\", Env.home_directory

    ENV["HOME"] = nil
    ENV["HOMEDRIVE"] = nil
    ENV["HOMEPATH"] = "\\Program Files\\User"
    
    assert_equals "\\Program Files\\User", Env.home_directory
    
    ENV["HOME"] = nil
    ENV["HOMEDRIVE"] = "c:"
    ENV["HOMEPATH"] = "\\Program Files\\User"
    
    # assert_equals "c:\\Program Files\\User", Env.home_directory
  end

  def do_split_test(expected, input)
    ENV["FOO"] = input
    
    result = Env.split("FOO")

    assert_equals expected, result
  end
  
  def test_split
    do_split_test(%w{ testing }, "testing")
    do_split_test(%w{ this is }, "this is")
    do_split_test(%w{ this is }, '"this" "is"')
    do_split_test(%w{ this is a test }, '"this" "is" \'a\' "test"')
    do_split_test(%w{ this is a tes't }, '"this" "is" \'a\' "tes\'t"')
  end

end
