# Centrify facter facts
require 'facter'

# centrify mode
Facter.add('centrify_mode') do
  confine :kernel => :linux

  setcode do
    if File::executable?("/usr/bin/adinfo")
      mode = Facter::Util::Resolution.exec("/usr/bin/adinfo -m")
      mode.empty? ? 'null' : mode
    else
      'null'
    end
  end
end

# centrify domain controller
Facter.add('centrify_dc') do
  confine :kernel => :linux

  setcode do
    if File::executable?("/usr/bin/adinfo")
      dc = Facter::Util::Resolution.exec('/usr/bin/adinfo -r')
      dc.empty? ? 'null' : dc
    else
      nil
    end
  end
end

# centrify domain
Facter.add('centrify_domain') do
  confine :kernel => :linux

  setcode do
    if File::executable?("/usr/bin/adinfo")
      domain = Facter::Util::Resolution.exec('/usr/bin/adinfo -d')
      domain.empty? ? 'null' : domain
    else
      nil
    end
  end
end


# centrify zone
Facter.add('centrify_zone') do
  confine :kernel => :linux

  setcode do
    if File::executable?("/usr/bin/adinfo")
      zone = Facter::Util::Resolution.exec('/usr/bin/adinfo -z')
      zone.empty? ? 'null' : zone
    else
      nil
    end
  end
end
