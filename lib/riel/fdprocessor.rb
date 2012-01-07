#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'riel'

# File and directory processor, with filtering.

class FileDirProcessor
  def initialize args, filter = nil
    @filter = filter
    args.each do |arg|
      process Pathname.new arg
    end
  end

  def process_file file
  end

  def process_directory dir
    dir.children.sort.each do |fd|
      next if @filter && @filter.include?(fd.basename.to_s)
      process fd
    end
  end

  def process fd
    if fd.directory?
      process_directory fd
    elsif fd.file?
      process_file fd
    else
      process_unknown_type fd
    end
  end

  def process_unknown_type fd
  end
end
