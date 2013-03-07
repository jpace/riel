#!/usr/bin/ruby -w
# -*- ruby -*-
#!ruby -w

require 'date'

module RIEL
  module DateExt
    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      # Returns the number of days in the given month.
      def days_in_month year, month
        (Date.new(year, 12, 31) << (12 - month)).day
      end
    end
  end
end
