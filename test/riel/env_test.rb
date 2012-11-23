#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/env'

class EnvTestCase < Test::Unit::TestCase
  def test_home_directory
    # Unix
    
    ENV["HOME"] = "/home/me"
    
    assert_equal "/home/me", Env.home_directory

    # Windows
    
    ENV["HOME"] = nil
    ENV["HOMEDRIVE"] = "c:"
    
    assert_equal "c:\\", Env.home_directory

    ENV["HOME"] = nil
    ENV["HOMEDRIVE"] = nil
    ENV["HOMEPATH"] = "\\Program Files\\User"
    
    assert_equal "\\Program Files\\User", Env.home_directory
    
    ENV["HOME"] = nil
    ENV["HOMEDRIVE"] = "c:"
    ENV["HOMEPATH"] = "\\Program Files\\User"
    
    # assert_equal "c:\\Program Files\\User", Env.home_directory
  end

  def run_split_test expected, input
    ENV["FOO"] = input
    result = Env.split "FOO"
    assert_equal expected, result
  end
  
  def test_split
    run_split_test %w{ testing }, "testing"
    run_split_test %w{ this is }, "this is"
    run_split_test %w{ this is }, '"this" "is"'
    run_split_test %w{ this is a test }, '"this" "is" \'a\' "test"'
    run_split_test %w{ this is a tes't }, '"this" "is" \'a\' "tes\'t"'
  end
end
