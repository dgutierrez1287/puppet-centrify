# Centrify facter facts
require 'facter'

# centrify_connected: true/nil
Facter.add('centrify_connected') do
  confine :kernel => :linux

  setcode do
    connected = nil
    if File::executable?("/usr/bin/adinfo")
      connected = Facter::Util::Resolution.exec("/usr/bin/adinfo -m")
      if connected == connected
        connected = true
      end
    end
    connected
  end
end

# centrify domain controller
Facter.add('centrify_dc') do
  confine :centrify_connected => true

  setcode do
    dc = Facter::Util::Resolution.exec('/usr/bin/adinfo -r')
    dc.nil? ? nil : dc
  end
end

# centrify domain
Facter.add('centrify_domain') do
  confine :centrify_connected => true

  setcode do
    domain = Facter::Util::Resolution.exec('/usr/bin/adinfo -d')
    domain.nil? ? nil : domain
  end
end

# centrify mode
Facter.add('centrify_mode') do

  setcode do
    mode = Facter::Util::Resolution.exec('/usr/bin/adinfo -m')
    mode.nil? ? nil : mode
  end
end

# centrify zone
Facter.add('centrify_zone') do
  confine :centrify_connected => true

  setcode do
    zone = Facter::Util::Resolution.exec('/usr/bin/adinfo -z')
    zone.nil? ? nil : zone
  end
end
