#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/text/ansi/ansi_list'

module Text
  class Attributes < ANSIList
    def initialize 
      super Hash[
                 'none'       => '0', 
                 'reset'      => '0',
                 'bold'       => '1',
                 'underscore' => '4',
                 'underline'  => '4',
                 'blink'      => '5',
                 'negative'   => '7',
                 'concealed'  => '8',
                ]
    end
  end
end
