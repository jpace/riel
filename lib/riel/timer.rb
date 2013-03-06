#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/log'

class Timer

  def initialize what, args = Hash.new
    if args.kind_of? Fixnum
      args = { :level => args }
    end

    @io    = args[:io]    || $stdout
    @level = args[:level] || Logue::Log::DEBUG
    
    stmsg  = args.include?(:startmsg) ? args[:startmsg] : "#{what} start time"
    endmsg = args.include?(:endmsg)   ? args[:endmsg]   : "#{what} end   time"
    elmsg  = args.include?(:elmsg)    ? args[:elmsg]    : "#{what} elapsed   "
    
    sttime = Time.new
    logmsg stmsg,  sttime
    
    yield
    
    endtime = Time.new
    
    logmsg stmsg,  sttime
    logmsg endmsg, endtime
    logmsg elmsg,  endtime - sttime
  end

  def logmsg msg, value
    if msg
      if @io
        @io.puts "#{msg}: #{value}"
      else
        Logue::Logue::Log.log "#{msg}: #{value}", @level
      end
    end
  end

end

def timethis what
  sttime = Time.new
  Logue::Log.log "#{what} start time: #{sttime}"
  yield
  endtime = Time.new
  Logue::Log.log "#{what} start time: #{sttime}"
  Logue::Log.log "#{what} end time  : #{endtime}"
  Logue::Log.log "#{what} elapsed   : #{endtime - sttime}"
end
