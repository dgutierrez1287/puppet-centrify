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
  $local_allow            = true
  $group_overrides        = []
  $groups_allow           = []
  $users_allow            = []
  $adjoin_user            = ''
  $adjoin_password        = ''
  $adjoin_domain          = ''
  $adjoin_server          = ''
  $adjoin_enterprise_zone = ''
  $adjoin_container       = ''
  $adjoin_force           = false
  $private_group          = true
  $primary_gid            = ''
  $auto_join              = true
  $cache_flush_int        = '24'
  $cache_obj_life         = '24'
  $log_buffer             = false
  $maximum_password_age   = '90'
  $minimum_password_age   = '1'
  $password_warn          = '14'
  $lockout_duration       = '30'
  $lockout_bad_count      = '0'
  $sntp_enabled           = false
  $merge_groups           = false
  $manage_conf            = false
}
