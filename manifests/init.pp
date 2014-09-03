# Class: centrify
#
# This module manages centrify, associated config files and
# will join the computer to the domain automatically, Note:
# this module does require a repo that contains the centrify packages
#
# for a full list of parameters please see the README
#
# Actions: installes the centrify packages, pushed out the config file
# from the templates and joins the system to the domain
#
# Requires: see Modulefile
#
#
class centrify (
  $dc_package_name        = $centrify::params::dc_package_name,
  $dc_package_ensure      = $centrify::params::dc_package_ensure,
  $dc_service_name        = $centrify::params::dc_service_name,
  $dc_service_enable      = $centrify::params::dc_service_enable,
  $dc_service_ensure      = $centrify::params::dc_service_ensure,
  $ssh_package_name       = $centrify::params::ssh_package_name,
  $ssh_package_ensure     = $centrify::params::ssh_package_ensure,
  $ssh_service_name       = $centrify::params::ssh_service_name,
  $ssh_service_enable     = $centrify::params::ssh_service_enable,
  $ssh_service_ensure     = $centrify::params::ssh_service_ensure,
  $auth_servers           = $centrify::params::auth_servers,
  $groups_allow           = $centrify::params::groups_allow,
  $users_allow            = $centrify::params::users_allow,
  $adjoin_user            = $centrify::params::adjoin_user,
  $adjoin_password        = $centrify::params::adjoin_password,
  $adjoin_domain          = $centrify::params::adjoin_domain,
  $adjoin_server          = $centrify::params::adjoin_server,
  $private_group          = $centrify::params::private_group,
  $primary_gid            = $centrify::params::primary_gid,
  $auto_join              = $centrify::params::auto_join,
  $maximum_password_age   = $centrify::params::maximum_password_age,
  $minimum_password_age   = $centrify::params::minimum_password_age,
  $lockout_duration       = $centrify::params::lockout_duration,
  $lockout_bad_count      = $centrify::params::lockout_bad_count,
  $merge_groups           = $centrify::params::merge_groups,
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
  validate_array($groups_allow)
  validate_array($users_allow)
  validate_string($adjoin_user)
  validate_string($adjoin_password)
  validate_string($adjoin_domain)
  validate_string($adjoin_server)
  validate_bool($private_group)
  validate_string($primary_gid)
  validate_bool($auto_join)
  validate_string($maximum_password_age)
  validate_string($minimum_password_age)
  validate_string($lockout_duration)
  validate_string($lockout_bad_count)
  validate_bool($merge_groups)

  # include classes for install, config and services
  include '::centrify::install'
  include '::centrify::config'
  include '::centrify::service'

  # set anchors for begin and end
  anchor { '::centrify::begin': }
  anchor { '::centrify::end': }

  # ordering of class execution
  Anchor ['::centrify::begin'] -> Class ['::centrify::install'] ->
  Class['::centrify::config'] ~> Class['::centrify::service'] ->
  Anchor['::centrify::end']
}
