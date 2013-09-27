#  Class centrify::service
#
#  This class will configure the services for
#  centrify and also will join the system to the
#  domain 
#
#
class centrify::service inherits centrify {

  # Error check for the dc_service ensure option
  if ! ($::dc_service_ensure in [ 'running', 'stopped' ]) {
    fail('dc_service_ensure parameter must be running or stopped')
  }

  # Error check for the ssh_service ensure option
  if ! ($::ssh_service_ensure in [ 'running', 'stopped' ]) {
    fail('ssh_service_ensure parameter must be running or stopped')
  }



  service {'centrify-ssh-service':
    ensure     => $::ssh_service_ensure,
    name       => $::ssh_service_name,
    hasrestart => true,
    hasstatus  => true,
    enable     => $::ssh_service_enable,
    subscribe  => [
      File['/etc/centrifydc/sshd_config'],
      File['/etc/centrifydc/centrifydc.conf'],
      File['/etc/centrifydc/groups.allow'],
      File['/etc/centrifydc/users.allow'],
    ],
    notify     => Exec['adflush'],
  }

  service {'centrify-dc-service':
    ensure     => $::dc_service_ensure,
    name       => $::dc_service_name,
    hasrestart => true,
    hasstatus  => true,
    enable     => $::dc_service_enable,
    subscribe  => [
      File['/etc/centrifydc/sshd_config'],
      File['/etc/centrifydc/centrifydc.conf'],
      File['/etc/centrifydc/groups.allow'],
      File['/etc/centrifydc/users.allow'],
    ],
    notify     => Exec['adflush'],
  }

  # ad-join
  exec { 'adjoin':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "adjoin -w -n ${hostname} -u ${::adjoin_user} -p ${::adjoin_password}  ${::adjoin_domain}",
    refreshonly => true,
  }

  #adflush
  exec { 'adflush':
    path        => '/usr/local/bin:/bin:/usr/bin:/usr/sbin',
    command     => '/usr/sbin/adflush && /usr/sbin/adreload',
    refreshonly => true,
  }
}