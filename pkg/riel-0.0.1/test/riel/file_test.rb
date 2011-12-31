#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubyunit'
require 'riel/file'
require 'riel/tempfile'
require 'pathname'


class FileTestCase < RUNIT::TestCase

  def get_file_rootname
    Pathname.new(__FILE__).rootname
  end

  def create_text_file
    rootname = Pathname.new(__FILE__).rootname
    Tempfile.open(rootname) do |tf|
      tf.puts "this is some text"
      tf.puts "this is more text"
      tf.puts "even more text"
      tf.puts "and some final text"
    end
  end

  def create_binary_file
    stringio_so = "/usr/lib/ruby/1.8/i386-linux/stringio.so"

    tempname = nil

    if File.exist?(stringio_so)
      rootname = Pathname.new(__FILE__).rootname
      tempname = Tempfile.open(rootname) do |tf|
        tf.write IO.read(stringio_so)
      end
    else
      $stderr.puts "not testing binary file: #{stringio_so} does not exist"
    end

    tempname
  end

  def test_file_types
    text_file = create_text_file
    assert(File.text?(text_file))
    assert(!File.binary?(text_file))
    
    if binary_file = create_binary_file
      assert(!File.text?(binary_file))
      assert(File.binary?(binary_file))
    end
  end

  def test_is_file_is_directory
    file = create_text_file

    dir = Pathname.new(file).dirname

    assert(File.is_file?(file))
    assert(!File.is_file?(dir))

    assert(!File.is_directory?(file))
    assert(File.is_directory?(dir))

    # this should have access only by root:

    file = "/var/log/httpd/error_log"
    assert(!File.is_file?(file))
    assert(!File.is_directory?(file))
    
  end

  def test_read_write_file
    filename = Tempfile.new(Pathname.new(__FILE__).rootname).path

    File.write_file(filename) do
      "hello, world"
    end

    line = nil
    File.read_file(filename) do |ln|
      line = ln
    end

    assert_equal("hello, world", line)
  end

  def test_read_put_file
    filename = Tempfile.new(Pathname.new(__FILE__).rootname).path

    File.put_file(filename) do
      "hello, world"
    end

    line = nil
    File.read_file(filename) do |ln|
      line = ln
    end

    assert_equal("hello, world\n", line)

    File.put_file(filename) do
      [
        "hello, world",
        "this is a test"
      ]
    end

    lines = Array.new
    File.read_file_lines(filename) do |ln|
      lines << ln
    end

    assert_equal([ "hello, world\n", "this is a test\n" ] , lines)
  end

  def test_open_via_temp_file
    fname = "/tmp/test_open_via_temp_file.#{$$}"

    pn = Pathname.new(fname)

    assert !pn.exist?
    
    File.open_via_temp_file(fname) do |io|
      assert !pn.exist?
      io.puts "this is a test"
    end

    assert pn.exist?

    pn.delete
  end

  def assert_files_existence(expected, files)
    files.each do |file|
      assert_equal expected, file.exist?
    end
  end

  def test_move_files
    tmp = Pathname.new("/tmp")
    
    assert tmp.exist?

    tgt = tmp + "movetest"

    fnums = 0 .. 3
    
    srcfiles = fnums.collect { |num| Pathname.new(tmp + "movefile#{num}") }

    # if the user has something there, we shouldn't delete it at the end of
    # these tests.

    assert !tgt.exist?
    
    begin
      tgt.mkdir
      
      srcfiles.each do |file|
        assert !file.exist?
        
        File.write_file(file) do
          "contents of file"
        end
        
        assert file.exist?
      end

      File.move_files(tgt, srcfiles)

      assert_files_existence(false, srcfiles)

      tgtfiles = fnums.collect { |num| tgt + "movefile#{num}" }

      assert_files_existence(true, tgtfiles)
    ensure
      if tgt && tgt.exist?
        tgt.children.each do |child|
          child.delete
        end

        tgt.delete if tgt && tgt.exist?
      end
      
      srcfiles.each do |file|
        file.delete if file && file.exist?
      end
    end
  end

  def test_copy_files
    tmp = Pathname.new("/tmp")
    
    assert tmp.exist?

    tgt = tmp + "copytest"

    fnums = 0 .. 3
    
    srcfiles = fnums.collect { |num| Pathname.new(tmp + "copyfile#{num}") }

    # if the user has something there, we shouldn't delete it at the end of
    # these tests.

    assert !tgt.exist?
    
    begin
      tgt.mkdir
      
      srcfiles.each do |file|
        assert !file.exist?
        
        File.write_file(file) do
          "contents of file"
        end
        
        assert file.exist?
      end

      File.copy_files(tgt, srcfiles)

      assert_files_existence(true, srcfiles)

      tgtfiles = fnums.collect { |num| tgt + "copyfile#{num}" }

      assert_files_existence(true, tgtfiles)
    ensure
      if tgt && tgt.exist?
        tgt.children.each do |child|
          child.delete
        end

        tgt.delete if tgt && tgt.exist?
      end
      
      srcfiles.each do |file|
        file.delete if file && file.exist?
      end
    end
  end

end
