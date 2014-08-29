#  Class centrify::params
#
#  This class contains the default params for
#  the centrify module
#
class centrify::params {

  case $::osfamily {
    'RedHat' : {
      $dc_package_name  = 'CentrifyDC'
      $ssh_package_name = 'CentrifyDC-openssh'
    }
    'Debian' : {
      $dc_package_name  = 'centrifydc'
      $ssh_package_name = 'centrifydc-openssh'
    }
    default  : {
      fail("${::osfamily} is not currently supported.")
    }
  }
  $dc_package_ensure   = 'present'
  $dc_service_name     = 'centrifydc'
  $dc_service_enable   = true
  $dc_service_ensure   = 'running'
  $ssh_package_ensure  = 'present'
  $ssh_service_name    = 'centrify-sshd'
  $ssh_service_enable  = true
  $ssh_service_ensure  = 'running'
  $auth_servers        = []
  $ssh_permit_root     = 'no'
  $ssh_port            = '22'
  $ssh_x11             = 'no'
  $ssh_banner          = '/etc/motd'
  $groups_allow        = []
  $users_allow         = []
  $adjoin_user         = ''
  $adjoin_password     = ''
  $adjoin_domain       = ''
  $adjoin_server       = ''
  $private_group       = true
  $primary_gid         = ''
  $auto_join           = true
  $maximumpasswordage  = '90'
  $minimumpasswordage  = '1'
  $lockoutduration     = '30'
  $lockoutbadcount     = '0'
}
