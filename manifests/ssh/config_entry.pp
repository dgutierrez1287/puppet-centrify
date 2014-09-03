# Manage centrify ssh conf entries. See README for details
define centrify::ssh::config_entry (
  $ensure = 'present',
  $value  = undef,
) {

  $centrifysshd_conf_path = '/etc/centrifydc/ssh/sshd_config'

  case $ensure {
    /present|absent/: {
      centrifyssh_conf { $name:
        ensure  => $ensure,
        target  => $centrifysshd_conf_path,
        value   => $value,
        notify  => Service['centrify-ssh-service'],
        require => Package['CentrifySSH'],
      }
    }

    default: {
      fail("Unknown value for ensure ${ensure}")
    }
  }
}