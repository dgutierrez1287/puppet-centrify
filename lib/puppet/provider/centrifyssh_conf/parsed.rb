require 'puppet/provider/parsedfile'

Puppet::Type.type(:centrifyssh_conf).provide(
    :parsed,
    :parent => Puppet::Provider::ParsedFile,
    :default_target => '/etc/centrifydc/ssh/sshd_config',
    :filetype => :flat
) do
  desc "Set key/values in centrify ssh conf"
  
  text_line :comment, :match => /^\s*#/
  text_line :blank, :match => /^\s*$/
  
  record_line :parsed,
    :fields   => %w{name value comment},
    :optional => %w{comment},
    :match    => /^\s*([\w\.]+)\s(.*?)(?:\s*#\s*(.*))?\s*$/,
    :to_line  => proc { |h| 
      
      str = h[:name]
      str += ' ' 
      str += h[:value]
      str += " # #{h[:comment]}" unless (h[:comment].nil? or h[:comment] == :absent)
      str
    },
    :post_parse => proc { |h|
      h[:name] # normalize case
      h[:value].gsub!(/(^'|'$)/, '') # strip out quotes
    }
  
end