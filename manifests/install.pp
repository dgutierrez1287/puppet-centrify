#  Class centrify::install
#
#  This class will install the DC and sshd package
#  that are part of the centrify install
#
#
class centrify::install {

  # Centrify Direct Control package
  package { 'CentrifyDC':
    ensure => $::centrify::dc_package_ensure,
    name   => $::centrify::dc_package_name,
  }

  # Centrify OpenSSH package
  package { 'CentrifySSH':
    ensure  => $::centrify::ssh_package_ensure,
    name    => $::centrify::ssh_package_name,
    require => Package['CentrifyDC']
  }

}