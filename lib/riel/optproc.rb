#!/usr/bin/ruby -w
# -*- ruby -*-

require 'riel/env'
require 'riel/log'
require 'riel/enumerable'

module OptProc
  class Option
    include Loggable

    attr_reader :md, :tags, :res

    ARG_INTEGER = %r{^ ([\-\+]?\d+)               $ }x
    ARG_FLOAT   = %r{^ ([\-\+]?\d* (?:\.\d+)?)    $ }x
    ARG_STRING  = %r{^ [\"\']? (.*?) [\"\']?      $ }x
    ARG_BOOLEAN = %r{^ (yes|true|on|no|false|off) $ }ix

    ARG_TYPES = Array.new
    ARG_TYPES << [ :integer, ARG_INTEGER ]
    ARG_TYPES << [ :float,   ARG_FLOAT   ]
    ARG_TYPES << [ :string,  ARG_STRING  ]
    ARG_TYPES << [ :boolean, ARG_BOOLEAN ]

    def initialize args = Hash.new, &blk
      @tags    = args[:tags] || Array.new
      @rc      = args[:rc]
      @rc      = [ @rc ] if @rc.kind_of?(String)
      @md      = nil
      @set     = blk || args[:set]
      
      @type    = nil
      @valuere = nil
      
      @argtype = nil

      @res     = args[:res]
      @res     = [ @res ] if @res.kind_of?(Regexp)
      
      if args[:arg]
        demargs = args[:arg].dup
        while arg = demargs.shift
          case arg
          when :required
            @type = "required"
          when :optional
            @type = "optional"
          when :none
            @type = nil
          when :regexp
            @valuere = demargs.shift
          else
            if re = ARG_TYPES.assoc(arg)
              @valuere   = re[1]
              @argtype   = arg
              @type    ||= "required"
            end
          end
        end
      end
    end

    def inspect
      '[' + @tags.collect { |t| t.inspect }.join(" ") + ']'
    end

    def to_str
      to_s
    end

    def to_s
      @tags.join " "
    end

    def match_rc? field
      @rc && @rc.include?(field)
    end

    def match_value val
      @md = @valuere && @valuere.match(val)
      @md && @md[1]
    end

    def match_tag tag
      if tm = @tags.detect do |t|
          t.index(tag) == 0 && tag.length <= t.length
        end
        
        if tag.length == tm.length
          1.0
        else
          tag.length.to_f * 0.01
        end
      else
        nil
      end
    end
    
    def match args, opt = args[0]
      return nil unless %r{^-}.match opt

      tag = opt.split('=', 2)[0] || opt

      @md = nil
      
      if @res && (@md = @res.collect { |re| re.match(opt) }.detect)
        1.0
      else
        match_tag tag
      end
    end

    def set_value args, opt = args[0]
      val = opt.split('=', 2)[1]
      args.shift

      if @md
        # already have match data
      elsif @type == "required"
        if val
          # already have value
        elsif args.size > 0
          val = args.shift
        else
          $stderr.puts "value expected"
        end

        if val
          match_value val
        end
      elsif @type == "optional"
        if val
          # already have value
          match_value val
        elsif args.size > 0
          if %r{^-}.match args[0]
            # skipping next value; apparently option
          elsif match_value args[0]
            # value matches
            args.shift
          end
        end
      end

      value = value_from_match

      set value, opt, args
    end

    def value_from_match
      if @md 
        if @argtype.nil? || @argtype == :regexp
          @md
        else
          convert_value @md[1]
        end
      elsif @argtype == :boolean
        true
      end
    end

    def convert_value val
      if val
        case @argtype
        when :string
          val
        when :integer
          val.to_i
        when :float
          val.to_f
        when :boolean
          to_boolean val
        when :regexp
          val
        when nil
          val
        else
          log { "unknown argument type: #{@type.inspect}" }
        end
      elsif @argtype == :boolean
        true
      end
    end

    def to_boolean val
      %w{ yes true on soitenly }.include? val.downcase
    end

    def set val, opt = nil, args = nil
      setargs = [ val, opt, args ].select_with_index { |x, i| i < @set.arity }
      @set.call(*setargs)
    end
  end

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
