#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'riel/rcfile'
require 'riel/tempfile'

class RCFileTestCase < Test::Unit::TestCase
  def test_simple
    separators = %w{ = : }
    leading_spaces = [ "", " ", "  " ]
    trailing_spaces = leading_spaces.dup
    comments = [ "", "# a comment" ]
    
    num = 0
    tempfile = Tempfile.open("rcfile_test") do |tf|
      tf.puts "# this is a comment"
      tf.puts ""
      
      separators.each do |sep|
        leading_spaces.each do |lsp|
          trailing_spaces.each do |tsp|
            comments.each do |cmt|
              tf.puts "#{lsp}name#{num}#{sep}value#{num}#{tsp}#{cmt}"
              num += 1
            end
          end
        end
      end
    end
      
    rc = RCFile.new tempfile
    (0 ... num).each do |i|
      assert_not_nil rc.settings[i]
      assert_equal [ "name#{i}", "value#{i}" ], rc.settings[i]
    end
  end
end
