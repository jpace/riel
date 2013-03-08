#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'riel/enumerable'
require 'riel/optproc/option'

module OptProc
  class OptionSet
    attr_reader :options
    
    def initialize data
      @options   = Array.new
      @shortopts = Array.new
      @longopts  = Array.new
      @regexps   = Hash.new
      
      data.each do |optdata|
        opt = OptProc::Option.new optdata
        @options << opt

        opt.tags.each do |tag|
          ch = tag[0]
          if ch == 45  # 45 = '-'
            ch = tag[1]
            assocopts = nil
            if ch == tag
              ch = tag[2]
              assocopts = @longopts
            else
              assocopts = @shortopts
            end
            
            (assocopts[ch] ||= Array.new) << opt
          end
          
          if res = opt.res
            res.each do |re|
              (@regexps[re] ||= Array.new) << opt
            end
          end
        end
      end
    end

    COMBINED_OPTS_RES = [
      #               -number       non-num
      Regexp.new('^ ( - \d+   )     ( \D+.* ) $ ', Regexp::EXTENDED),
      #               -letter       anything
      Regexp.new('^ ( - [a-zA-Z] )  ( .+    ) $ ', Regexp::EXTENDED)
    ]

    def process_option args
      opt = args[0]

      if md = COMBINED_OPTS_RES.collect { |re| re.match opt }.detect
        lhs = md[1]
        rhs = "-" + md[2]
        args[0, 1] = lhs, rhs
        
        return process_option args
      elsif opt[0] == 45
        ch = opt[1]
        assocopts = if ch == 45  # 45 = '-'
                      ch = opt[2]
                      @longopts[ch]
                    elsif ch.nil?
                      nil
                    else
                      @shortopts[ch]
                    end

        if assocopts && x = set_option(assocopts, args)
          return x
        end
      end

      if x = set_option(@options, args)
        return x
      elsif @bestmatch
        if @bestopts.size == 1
          @bestopts[0].set_value args
          return @bestopts[0]
        else
          optstr = @bestopts.collect { |y| '(' + y.tags.join(', ') + ')' }.join(', ')
          $stderr.puts "ERROR: ambiguous match of '#{args[0]}'; matches options: #{optstr}"
          exit 2
        end
      end

      nil
    end

    def set_option optlist, args
      @bestmatch = nil
      @bestopts  = Array.new
      
      optlist.each do |option|
        next unless mv = option.match(args)
        if mv >= 1.0
          # exact match:
          option.set_value args
          return option
        elsif !@bestmatch || @bestmatch <= mv
          @bestmatch = mv
          @bestopts  << option
        end
      end
      nil
    end
  end
end
