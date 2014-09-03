#  Class centrify::config
#
#  This class pushes out the needed config files from
#  the templates that are customized by the module parameters
#
#
class centrify::config {

  # Error check for no auth servers
  if size($::centrify::auth_servers) == 0 {
    fail('you must provide at least one auth server for this to work')
  }

  # Error check for no users or groups allowed in the system
  if size($::centrify::users_allow) == 0 {
    if size($::centrify::groups_allow) ==0 {
      fail('there are no users or groups to authenticate, this is not recommended')
    }
  }

  # Error check for missing domain name
  if size($::centrify::adjoin_domain) == 0 {
    fail('must have a domain name to set up auth servers')
  }
  else {
    if ! is_domain_name($::centrify::adjoin_domain){
      fail('domain name does not appear to be valid')
    }
  }

  # Error check if the join server is not given
  if size($::centrify::adjoin_server) == 0 {
    fail('you must give an ad server name to join to')
  }

  # Error check if the ssh_port that is given is a integer
  if ! is_integer($::centrify::ssh_port) {
    fail('port for ssh does not seem to be a number')
  }

  file {'/etc/centrifydc/centrifydc.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/centrifydc_config.erb'),
    notify  => Class['centrify::service'],
  }

  file {'/etc/centrifydc/groups.allow':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/groups_allow.erb'),
    notify  => Class['centrify::service'],
  }

  file {'/etc/centrifydc/users.allow':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/users_allow.erb'),
    notify  => Class['centrify::service']
  }

}