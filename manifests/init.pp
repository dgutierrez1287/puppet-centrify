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
  $local_allow            = $centrify::params::local_allow,
  $group_overrides        = $centrify::params::group_overrides,
  $groups_allow           = $centrify::params::groups_allow,
  $users_allow            = $centrify::params::users_allow,
  $adjoin_user            = $centrify::params::adjoin_user,
  $adjoin_password        = $centrify::params::adjoin_password,
  $adjoin_domain          = $centrify::params::adjoin_domain,
  $adjoin_server          = $centrify::params::adjoin_server,
  $adjoin_enterprise_zone = $centrify::params::adjoin_enterprise_zone,
  $adjoin_container       = $centrify::params::adjoin_container,
  $adjoin_force           = $centrify::params::adjoin_force,
  $private_group          = $centrify::params::private_group,
  $primary_gid            = $centrify::params::primary_gid,
  $auto_join              = $centrify::params::auto_join,
  $cache_flush_int        = $centrify::params::cache_flush_int,
  $cache_obj_life         = $centrify::params::cache_obj_life,
  $log_buffer             = $centrify::params::log_buffer,
  $maximum_password_age   = $centrify::params::maximum_password_age,
  $minimum_password_age   = $centrify::params::minimum_password_age,
  $password_warn          = $centrify::params::password_warn,
  $lockout_duration       = $centrify::params::lockout_duration,
  $lockout_bad_count      = $centrify::params::lockout_bad_count,
  $sntp_enabled           = $centrify::params::sntp_enabled,
  $merge_groups           = $centrify::params::merge_groups,
  $manage_conf            = $centrify::params::manage_conf,
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
  validate_bool($local_allow)
  validate_array($group_overrides)
  validate_array($groups_allow)
  validate_array($users_allow)
  validate_string($adjoin_user)
  validate_string($adjoin_password)
  validate_string($adjoin_domain)
  validate_string($adjoin_server)
  validate_string($adjoin_enterprise_zone)
  validate_string($adjoin_container)
  validate_bool($adjoin_force)
  validate_bool($private_group)
  validate_string($primary_gid)
  validate_bool($auto_join)
  validate_string($cache_flush_int)
  validate_string($cache_obj_life)
  validate_bool($log_buffer)
  validate_string($maximum_password_age)
  validate_string($minimum_password_age)
  validate_string($password_warn)
  validate_string($lockout_duration)
  validate_string($lockout_bad_count)
  validate_bool($sntp_enabled)
  validate_bool($merge_groups)
  validate_bool($manage_conf)

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
