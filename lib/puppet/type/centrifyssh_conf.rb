module Puppet
  newtype(:centrifyssh_conf) do
    
    @doc = "this type allows puppet to manage centrify's sshd conf"
    
    ensurable
    
    newparam(:name) do
      desc "The sshd parameter name to manage."
      isnamevar
    
      newvalues(/^[\w\.]+$/)
    end
    
    newproperty(:value) do
      desc "The value to set for this parameter."
    end
    
    newproperty(:target) do
      desc "The path to sshd.conf"
        defaultto {
          if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
             @resource.class.defaultprovider.default_target
          else
             nil
          end
        }
    end
  end
end