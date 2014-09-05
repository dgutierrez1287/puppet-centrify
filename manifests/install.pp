#  Class centrify::install
#
#  This class will install the DC and sshd package
#  that are part of the centrify install
#
#
class centrify::install {
  $dc_package_ensure  = $centrify::dc_package_ensure
  $dc_package_name    = $centrify::dc_package_name
  $ssh_package_ensure = $centrify::ssh_package_ensure
  $ssh_package_name   = $centrify::ssh_package_name

  # Centrify Direct Control package
  package { 'CentrifyDC':
    ensure => $dc_package_ensure,
    name   => $dc_package_name,
  }

  # Centrify OpenSSH package
  package { 'CentrifySSH':
    ensure  => $ssh_package_ensure,
    name    => $ssh_package_name,
    require => Package['CentrifyDC']
  }

}