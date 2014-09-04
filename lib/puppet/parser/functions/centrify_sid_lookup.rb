# a function to look up a user sid using centrify

module Puppet::Parser::Functions
  newfunction(:centrify_sid_lookup, :type => :rvalue, :doc => <<-EOS
    looks up a user sid using centrify tools 
    EOS
  ) do |args|
    
    raise(Puppet::ParseError, "centrify_sid_lookup(): Wrong number of arguements " + 
      "given (#{args.size} for 1)") if args.size != 1
      
      username = args[0]
      
      query_cmd = "adquery user #{username}"
      query_output = %x[#{query_cmd}] 
      
      query_output =~ /\w*:x:(?<sid>\d*):/
      
      centrify_sid = Regexp.last_match(:sid)
      
      return centrify_sid
  end
end