#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'pathname'
require 'riel/dir'
require 'riel/file'

class Dir
  include RIEL::DirExt
end

class DirTestCase < Test::Unit::TestCase
  def test_home
    assert_equal ENV["HOME"], Dir.home
  end

  def test_remove_if_empty
    # set up a mess of files in /tmp ...

    tmpdir = Pathname.new '/tmp'

    # maybe this isn't Linux (poor devils!):
    return unless tmpdir.exist?

    testdir = tmpdir + 'riel_dir_test'
    if testdir.exist?
      testdir.delete
    end

    testdir.mkdir
    assert testdir.exist?

    a = testdir + 'a'
    a.mkdir
    (0 .. 5).each do |ai|
      adir = a + "a#{ai}"
      adir.mkdir
    end

    Dir.remove_if_empty a, :verbose => false

    assert !a.exist?

    a = testdir + 'a'
    a.mkdir
    (0 .. 5).each do |ai|
      adir = a + "a#{ai}"
      adir.mkdir
      (0 .. 4).each do |aai|
        aafile = adir + "aa#{aai}"
        File.write_file(aafile) do
          (4 .. rand(50)).collect do |li|
            "line #{li}"
          end
        end
      end
    end

    Dir.remove_if_empty a
    assert a.exist?

    Dir.remove_if_empty(a, :deletable => [ %r{aa\d+} ])

    assert !a.exist?

    a = testdir + 'a'
    a.mkdir
    (0 .. 5).each do |ai|
      adir = a + "a#{ai}"
      adir.mkdir
      (0 .. 4).each do |aai|
        aafile = adir + "foo.bar"
        File.write_file(aafile) do
          (4 .. rand(50)).collect do |li|
            "line #{li}"
          end
        end
      end
    end

    Dir.remove_if_empty a
    assert a.exist?

    Dir.remove_if_empty a, :deletable => %w{ foo.bar }
    assert !a.exist?

    testdir.delete
  end
end
