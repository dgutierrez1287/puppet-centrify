#  Class centrify::service
#
#  This class will configure the services for
#  centrify and also will join the system to the
#  domain
#
#
class centrify::service {

  if $::centrify::auto_join {

    notice('running with auto_join enabled')

    # Error check for the dc_service ensure option
    if ! ($::centrify::dc_service_ensure in [ 'running', 'stopped' ]) {
      fail('dc_service_ensure parameter must be running or stopped')
    }

    # Error check for the ssh_service ensure option
    if ! ($::centrify::ssh_service_ensure in [ 'running', 'stopped' ]) {
      fail('ssh_service_ensure parameter must be running or stopped')
    }

    # ad-join
    exec { 'adjoin':
      path        => '/usr/bin:/usr/sbin:/bin',
      command     => "adjoin -w -u ${::centrify::adjoin_user} -s ${::centrify::adjoin_server} -p ${::centrify::adjoin_password} ${::centrify::adjoin_domain}",
      refreshonly => true,
    }

    #adflush
    exec { 'adflush':
      path        => '/usr/local/bin:/bin:/usr/bin:/usr/sbin',
      command     => '/usr/sbin/adflush && /usr/sbin/adreload',
      refreshonly => true,
    }

  service {'centrify-ssh-service':
      ensure     => $::centrify::ssh_service_ensure,
      name       => $::centrify::ssh_service_name,
      hasrestart => true,
      hasstatus  => true,
      enable     => $::centrify::ssh_service_enable,
      subscribe  => [
        File['/etc/centrifydc/ssh/sshd_config'],
        File['/etc/centrifydc/centrifydc.conf'],
        File['/etc/centrifydc/groups.allow'],
        File['/etc/centrifydc/users.allow'],
      ],
    notify       => Exec['adflush'],
  }

  service {'centrify-dc-service':
      ensure     => $::centrify::dc_service_ensure,
      name       => $::centrify::dc_service_name,
      hasrestart => true,
      hasstatus  => true,
      enable     => $::centrify::dc_service_enable,
      subscribe  => [
        File['/etc/centrifydc/ssh/sshd_config'],
        File['/etc/centrifydc/centrifydc.conf'],
        File['/etc/centrifydc/groups.allow'],
        File['/etc/centrifydc/users.allow'],
      ],
      notify     => Exec['adflush'],
    }

    Exec['adjoin'] -> Service['centrify-dc-service'] ->
    Service['centrify-ssh-service'] -> Exec['adflush']
  }
}