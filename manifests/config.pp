#  Class centrify::config
#
#  This class pushes out the needed config files from
#  the templates that are customized by the module parameters
#
#
class centrify::config {
  $auth_servers           = $centrify::auth_servers
  $users_allow            = $centrify::users_allow
  $groups_allow           = $centrify::groups_allow
  $adjoin_domain          = $centrify::adjoin_domain
  $adjoin_server          = $centrify::adjoin_server
  $adjoin_enterprise_zone = $centrify::adjoin_enterprise_zone
  $local_allow            = $centrify::local_allow
  $group_overrides        = $centrify::group_overrides
  $manage_conf            = $centrify::manage_conf

  # Error check for no zone and no auth servers
  if $adjoin_enterprise_zone == '' and size ($auth_servers) == 0 {
      fail('you must provide either a zone or at least one auth server for this to work')
  }

  # If using local allow files, error check for no users/groups allowed in the system
  if $local_allow == true {
    if size($users_allow) == 0 {
      if size($groups_allow) ==0 {
        fail('there are no users or groups to authenticate, this is not recommended')
      }
    }
  }

  # Error check for missing domain name
  if size($adjoin_domain) == 0 {
    fail('must have a domain name to set up auth servers')
  }
  else {
    if ! is_domain_name($adjoin_domain){
      fail('domain name does not appear to be valid')
    }
  }

  # If not joing a zone, error check if the join server is not given
  if $adjoin_enterprise_zone == '' {
    if size($adjoin_server) == 0 {
      fail('you must give an ad server name to join to')
    }
  }

  if $manage_conf == true {
    file {'/etc/centrifydc/centrifydc.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/centrifydc_config.erb'),
      notify  => [ Class['centrify::service'], Service['centrify-ssh-service'], Service['centrify-dc-service'] ],
    }
  }

  if $local_allow == true {
    file {'/etc/centrifydc/groups.allow':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/groups_allow.erb'),
      notify  => [ Class['centrify::service'], Service['centrify-ssh-service'], Service['centrify-dc-service'] ],
    }
  }
  else {
    file {'/etc/centrifydc/group.allow':
      ensure => 'absent'
    }
  }

  if $local_allow == true {
    file {'/etc/centrifydc/users.allow':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/users_allow.erb'),
      notify  => [ Class['centrify::service'], Service['centrify-ssh-service'], Service['centrify-dc-service'] ],
    }
  }
  else {
    file {'/etc/centrifydc/users.allow':
      ensure => 'absent'
    }
  }

  if ! empty($group_overrides) {
    file {'/etc/centrifydc/group.ovr':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/group.ovr.erb'),
      notify  => [ Class['centrify::service'], Service['centrify-ssh-service'], Service['centrify-dc-service'] ],
    }
  }
  else {
    file {'/etc/centrifydc/group.ovr':
      ensure => 'absent'
    }
  }

}
