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
  $dc_package_ensure      = 'present'
  $dc_service_name        = 'centrifydc'
  $dc_service_enable      = true
  $dc_service_ensure      = 'running'
  $ssh_package_ensure     = 'present'
  $ssh_service_name       = 'centrify-sshd'
  $ssh_service_enable     = true
  $ssh_service_ensure     = 'running'
  $auth_servers           = []
  $groups_allow           = []
  $users_allow            = []
  $adjoin_user            = ''
  $adjoin_password        = ''
  $adjoin_domain          = ''
  $adjoin_server          = ''
  $private_group          = true
  $primary_gid            = ''
  $auto_join              = true
  $maximum_password_age   = '90'
  $minimum_password_age   = '1'
  $lockout_duration       = '30'
  $lockout_bad_count      = '0'
  $merge_groups           = false
}
