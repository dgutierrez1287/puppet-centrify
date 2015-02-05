#  Class centrify::service
#
#  This class will configure the services for
#  centrify and also will join the system to the
#  domain
#
#
class centrify::service {
  $auto_join          = $centrify::auto_join
  $dc_service_ensure  = $centrify::dc_service_ensure
  $ssh_service_ensure = $centrify::ssh_service_ensure
  $adjoin_server      = $centrify::adjoin_server
  $adjoin_password    = $centrify::adjoin_password
  $adjoin_domain      = $centrify::adjoin_domain
  $adjoin_user        = $centrify::adjoin_user
  $adjoin_zone        = $centrify::adjoin_zone
  $adjoin_container   = $centrify::adjoin_container
  $adjoin_force       = $centrify::adjoin_force
  $ssh_service_enable = $centrify::ssh_service_enable
  $ssh_service_name   = $centrify::ssh_service_name
  $dc_service_name    = $centrify::dc_service_name
  $dc_service_enable  = $centrify::dc_service_enable
  $local_allow        = $centrify::local_allow

  if $local_allow == true {
    $config = [File['/etc/centrifydc/centrifydc.conf'],
              File['/etc/centrifydc/groups.allow'],
              File['/etc/centrifydc/users.allow'],
              ]
  }
  else {
    $config = [File['/etc/centrifydc/centrifydc.conf'],
              ]
  }

  if $auto_join {

    notice('running with auto_join enabled')

    # Error check for the dc_service ensure option
    if ! ($dc_service_ensure in [ 'running', 'stopped' ]) {
      fail('dc_service_ensure parameter must be running or stopped')
    }

    # Error check for the ssh_service ensure option
    if ! ($ssh_service_ensure in [ 'running', 'stopped' ]) {
      fail('ssh_service_ensure parameter must be running or stopped')
    }

    # ad-join workstation
    exec { 'adjoin workstation':
      path      => '/usr/bin:/usr/sbin:/bin',
      command   => "adjoin -w -u ${adjoin_user} -s ${adjoin_server} -p ${adjoin_password} ${adjoin_domain}",
      onlyif    => ['test `adinfo -d | wc -l` -eq 0',
                    "test '${adjoin_zone}' = ''"
                    ],
      logoutput => true,
    }

    # ad-join zone
    exec { 'adjoin zone':
      path      => '/usr/bin:/usr/sbin:/bin',
      command   => "adjoin -u ${adjoin_user} -p ${adjoin_password} -c ${adjoin_container} -z ${adjoin_zone} -n ${::fqdn} -f ${adjoin_domain}",
      onlyif    => ['test `adinfo -d | wc -l` -eq 0',
                    "test '${adjoin_zone}' != ''"
                    ],
      logoutput => true,
    }

    #adflush
    exec { 'adflush':
      path        => '/usr/local/bin:/bin:/usr/bin:/usr/sbin',
      command     => '/usr/sbin/adflush && /usr/sbin/adreload',
      refreshonly => true,
    }

    service {'centrify-ssh-service':
      ensure     => $ssh_service_ensure,
      name       => $ssh_service_name,
      hasrestart => true,
      hasstatus  => true,
      enable     => $ssh_service_enable,
      subscribe  => $config,
      notify     => Exec['adflush'],
    }

    service {'centrify-dc-service':
      ensure     => $dc_service_ensure,
      name       => $dc_service_name,
      hasrestart => true,
      hasstatus  => true,
      enable     => $dc_service_enable,
      subscribe  => $config,
      notify     => Exec['adflush'],
    }

    if $adjoin_zone != '' {
      Exec['adjoin zone'] -> Service['centrify-dc-service'] ->
      Service['centrify-ssh-service'] -> Exec['adflush']
    }
    else {
      Exec['adjoin workstation'] -> Service['centrify-dc-service'] ->
      Service['centrify-ssh-service'] -> Exec['adflush']
    }
  }
}
