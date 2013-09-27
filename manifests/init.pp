# Class: centrify
#
# This module manages centrify
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class centrify (
  $dc_package_name     = $centrify::params::dc_package_name,
  $dc_package_ensure   = $centrify::params::dc_package_ensure,
  $dc_service_name     = $centrify::params::dc_service_name,
  $dc_service_enable   = $centrify::params::dc_service_enable,
  $dc_service_ensure   = $centrify::params::dc_service_ensure,
  $ssh_package_name    = $centrify::params::ssh_package_name,
  $ssh_package_ensure  = $centrify::params::ssh_package_ensure,
  $ssh_service_name    = $centrify::params::ssh_service_name,
  $ssh_service_enable  = $centrify::params::ssh_service_enable,
  $ssh_service_ensure  = $centrify::params::ssh_service_ensure,
  $auth_servers        = $centrify::params::auth_servers,
  $ssh_permit_root     = $centrify::params::ssh_permit_root,
  $ssh_port            = $centrify::params::ssh_port,
  $ssh_x11             = $centrify::params::ssh_x11,
  $ssh_banner          = $centrify::params::ssh_banner,
  $groups_allow        = $centrify::params::groups_allow,
  $users_allow         = $centrify::params::users_allow,
  $domain_name         = $centrify::params::domain_name,
  $adjoin_user         = $centrify::params::adjoin_user,
  $adjoin_password     = $centrify::params::adjoin_password,
  $adjoin_domain       = $centrify::params::adjoin_domain,
) inherits centrify::params {

  # validate parameters
  validate_string($dc_package_name)
  validate_string($dc_package_ensure)
  validate_string($dc_service_name)
  validate_bool($dc_service_enable)
  validate_string($dc_service_ensure)
  validate_string($ssh_package_name)
  validate_string($ssh_package_ensure)
  validate_string($ssh_service_name)
  validate_bool($ssh_service_enable)
  validate_string($ssh_service_ensure)
  validate_array($auth_servers)
  validate_string($ssh_permit_root)
  validate_string($ssh_port)
  validate_string($ssh_x11)
  validate_absolute_path($ssh_banner)
  validate_array($groups_allow)
  validate_array($users_allow)
  validate_string($domain_name)
  validate_string($adjoin_user)
  validate_string($adjoin_password)
  validate_string($adjoin_domain)

  # include classes for install, config and services
  include '::centrify::install'
  include '::centrify::config'
  include '::centrify::service'

  # set anchors for begin and end
  anchor { 'centrify::begin': }
  anchor { 'centrify::end': }

  # ordering of class execution
  Anchor ['centrify::begin'] -> Class ['::centrify::install'] -> Class['::centrify::config'] ~> Class['::centrify::service'] -> Anchor['centrify::end']
}
