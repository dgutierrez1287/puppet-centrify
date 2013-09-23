
class centrify::install inherits centrify {
  
  # Centrify Direct Control package 
  package { "CentrifyDC":
    ensure => $dc_package_ensure,
    name => $dc_package_name,
    notify => Exec['adjoin']
  }
  
  # Centrify OpenSSH package
  package { "CentrifySSH":
    ensure => $ssh_package_ensure,
    name => $ssh_package_name,
    require => Package['CentrifyDC']
  }
  
}