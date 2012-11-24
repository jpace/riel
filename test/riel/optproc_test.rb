#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'tempfile'
require 'test/unit'
require 'riel/optproc'

class OptProcTestCase < Test::Unit::TestCase
  def setup
    # ignore what they have in ENV[HOME]    
    ENV['HOME'] = '/this/should/not/exist'
  end

  def run_test args, exp, &blk
    expected = DEFAULTS.merge(exp)

    # ignore what they have in ENV[HOME]    
    ENV['HOME'] = '/this/should/not/exist'

    origargs = args.dup
    
    gopt = GlarkOptions.instance
    gopt.run args
    
    expected.sort { |a, b| a[0].to_s <=> b[0].to_s }.each do |opt, exval|
      meth = gopt.method(opt)
      val  = meth.call
      if val.kind_of? Array
        assert_equal exval.length, val.length, "#{opt} => #{exval.class}.length #{exval.inspect}; #{val.class}.length #{val.inspect}; #{origargs.inspect}"
        (0 ... exval.length).each do |idx|
          assert_equal exval[idx], val[idx], "#{opt}[#{idx}] => #{exval.class}.length #{exval.inspect}; #{val.class}.length #{val.inspect}; #{origargs.inspect}"
        end
      else
        assert_equal exval, val, "#{opt} => #{exval.class} #{exval.inspect}; #{val.class} #{val.inspect}; #{origargs.inspect}"
      end
    end
    
    blk.call(gopt) if blk

    gopt.reset
  end

  def run_match_tag_test opt, exp, tag
    m = opt.match [ tag ]
    match = nil
    if exp.respond_to? :include?
      match = exp.include? m
    else
      match = exp == m
    end
    assert match, "match_tag(#{tag}): expected: #{exp.inspect}; actual: #{m.inspect}"
  end
  
  def test_match_tag
    @after = "nothing"
    opt = OptProc::Option.new :tags => %w{ --after-context -A }, :arg => [ :integer ]
    
    %w{ --after-context --after-context=3 -A }.each do |tag|
      run_match_tag_test opt, 1.0, tag
    end

    run_match_tag_test opt, nil, '-b'
    
    # we don't support case insensitivity (which is insensitive of us):
    %w{ --After-Context --AFTER-CONTEXT=3 -a }.each do |tag|
      run_match_tag_test opt, nil, tag
    end

    %w{ --after --after=3 }.each do |tag|
      run_match_tag_test opt, 0.07, tag
    end

    %w{ --after-cont --after-cont=3 }.each do |tag|
      run_match_tag_test opt, 0.12, tag
    end

    %w{ --aft --aft=3 }.each do |tag|
      run_match_tag_test opt, 0.05, tag
    end
  end

  def run_match_value_test(opt, exp, val)
    m = opt.match_value val
    assert !!m == !!exp, "match value #{val}; expected: #{exp.inspect}; actual: #{m.inspect}"
  end

  def test_value_none
    opt = OptProc::Option.new(:arg  => [ :none ])

    {
      '34'    => nil,
      '43'    => nil,
      '34.12' => nil
    }.each do |val, exp|
      run_match_value_test opt, exp, val
    end
  end

  def test_value_integer
    opt = OptProc::Option.new(:arg => [ :integer ])

    {
      '34'    => true,
      '43'    => true,
      '34.12' => nil,
      '-34'   => true,
      '+34'   => true,
    }.each do |val, exp|
      run_match_value_test opt, exp, val
    end
  end

  def test_value_float
    opt = OptProc::Option.new(:arg  => [ :float ])

    {
      '34'    => true,
      '43'    => true,
      '34.12' => true,
      '.12'   => true,
      '.'     => false,
      '12.'   => false,
    }.each do |val, exp|
      run_match_value_test opt, exp, val
    end
  end

  def test_value_string
    opt = OptProc::Option.new(:arg  => [ :string ])

    {
      '34'    => true,
      '43'    => true,
      '34.12' => true,
      '.12'   => true,
      '.'     => true,
      '12.'   => true,
      'hello' => true,
      'a b c' => true,
      ''      => true,
    }.each do |val, exp|
      [ 
        '"' + val + '"',
        "'" + val + "'",
        val,
      ].each do |qval|
        run_match_value_test opt, exp, qval
      end
    end
  end

  def test_after_context_float
    @after = nil
    opt = OptProc::Option.new(:tags => %w{ --after-context -A },
                              :arg  => [ :required, :float ],
                              :set  => Proc.new { |val| @after = val })
    [ 
      %w{ --after-context 3 },
      %w{ --after-context=3 },
      %w{ -A              3 },
    ].each do |args|
      @after = nil

      m = opt.match args
      assert_equal 1.0, m, "args: #{args.inspect}"
      # curr = args.shift
      opt.set_value args
      assert_equal 3.0, @after
    end
  end

  def test_regexp_option
    @after = nil
    opt = OptProc::Option.new(:res  => %r{ ^ - ([1-9]\d*) $ }x,
                              :tags => %w{ --context -C },
                              :arg  => [ :optional, :integer ],
                              :set  => Proc.new { |val| @ctx = val })
    [ 
      %w{ --context 3 },
      %w{ --context=3 },
      %w{ -C        3 },
    ].each do |args|
      @ctx = nil

      m = opt.match args
      assert_equal 1.0, m, "args: #{args.inspect}"
      opt.set_value args
      assert_equal 3, @ctx
    end

    vals = (1 .. 10).to_a  | (1 .. 16).collect { |x| 2 ** x }
    # vals = [ 4 ]
    vals.each do |val|
      args = [ '-' + val.to_s, 'foo' ]

      @ctx = nil

      m = opt.match args
      assert_equal 1.0, m, "args: #{args.inspect}"
      opt.set_value args
      assert_equal val, @ctx
    end
  end

  def test_value_regexp
    @range_start = nil
    opt = OptProc::Option.new(:tags => %w{ --after },
                              :arg  => [ :required, :regexp, %r{ ^ (\d+%?) $ }x ],
                              :set  => Proc.new { |md| @range_start = md[1] })
    
    %w{ 5 5% 10 90% }.each do |rg|
      [
        [ '--after',   rg ],
        [ '--after=' + rg ]
      ].each do |args|
        @range_start = nil
        
        m = opt.match args
        assert_equal 1.0, m, "args: #{args.inspect}"
        opt.set_value args
        assert_equal rg, @range_start
      end
    end
  end

end

if __FILE__ == $0
  Log.level = Log::DEBUG
end
