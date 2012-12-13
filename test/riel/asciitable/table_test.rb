#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'test/unit'
require 'riel/asciitable/table'
require 'stringio'

module RIEL::ASCIITable
  class TableTest < Test::Unit::TestCase
    class DogData < TableData
      def initialize 
        @data = Array.new
        add_dog 'lucky', 'mixed', 'Illinois'
        add_dog 'frisky', 'dachshund', 'Illinois'
        add_dog 'boots', 'beagle', 'Indiana'
        add_dog 'sandy', 'ridgeback', 'Indiana'
        add_dog 'cosmo', 'retriever', 'Virginia'
      end

      def add_dog name, breed, state
        @data << [name, breed, state ]
      end
      
      def keys
        @data.collect { |dog| dog[0] }
      end

      def fields
        [ :breed, :state ]
      end

      def value key, field, index
        @data.assoc(key.to_s)[fields.index(field) + 1]
      end
    end

    class MyTable < Table
      attr_reader :data
      
      def initialize 
        @data = DogData.new
        super Hash.new
      end

      def headings
        %w{ name } + @data.fields.collect { |x| x.to_s }
      end
    end

    def test_defaults
      table = MyTable.new
      origout = $stdout
      sio = StringIO.new
      $stdout = sio
      table.print
      sio.flush
      str = sio.string
      $stdout = origout

      expected = [
                  "|     name     |    breed     |    state     |\n",
                  "| ------------ | ------------ | ------------ |\n",
                  "| lucky        | mixed        | Illinois     |\n",
                  "| frisky       | dachshund    | Illinois     |\n",
                  "| boots        | beagle       | Indiana      |\n",
                  "| sandy        | ridgeback    | Indiana      |\n",
                  "| cosmo        | retriever    | Virginia     |\n",
                 ]
      puts "-------------------------------------------------------"
      puts str
      puts "-------------------------------------------------------"

      assert_equal expected.join(''), str
    end
  end
end
