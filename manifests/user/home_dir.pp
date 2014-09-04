# a define to manage a centrify users home directory
define centrify::user::home_dir (
  $ensure           = 'present',
  $sid              = '',
  $bashrc_file      = '',
  $ssh_public_key   = '',
  $ssh_private_key  = '',
  $authorized_keys  = '',
) {

  case $ensure {
    /present|absent/: {

      # main home directory
      if $ensure == 'present' {
        file {"/home/${name}":
          ensure  => 'directory',
          owner   => $sid,
          group   => $sid,
          mode    => 0600,
        }

        # bashrc file
        if ! empty($bashrc_file) {
          file {"/home/${name}/.bashrc":
            ensure  => 'present',
            owner   => $sid,
            group   => $sid,
            mode    => 0740,
            source  => $bashrc_file,
            require => File["/home/${name}"],
          }
        }
        else {
          file {"/home/${name}/.bashrc":
            ensure => 'absent',
          }
        }

        # .ssh directory
        if (! empty($ssh_public_key)) or (! empty($ssh_private_key)) or (! empty($authorized_keys)) {
          file {"/home/${name}/.ssh":
            ensure  => 'directory',
            owner   => $sid,
            group   => $sid,
            mode    => 0600,
            require => File["/home/${name}"],
          }

          # ssh public key
          if ! empty($ssh_public_key) {
            file {"/home/${name}/.ssh/id_rsa.pub":
              ensure  => 'present',
              owner   => $sid,
              group   => $sid,
              mode    => 0744,
              source  => $ssh_public_key,
              require => File["/home/${name}/.ssh"],
            }
          }
          else {
            file {"/home/${name}/.ssh/id_rsa.pub":
              ensure  => 'absent',
            }
          }
          # ssh private key
          if ! empty($ssh_private_key) {
            file {"/home/${name}/.ssh/id_rsa":
              ensure  => 'present',
              owner   => $sid,
              group   => $sid,
              mode    => 0744,
              source  => $ssh_private_key,
              require => File["/home/${name}/.ssh"],
            }
          }
          else {
            file {"/home/${name}/.ssh/id_rsa":
              ensure  => 'absent',
            }
          }
          # ssh authorized keys
          if ! empty($authorized_keys) {
            file {"/home/${name}/.ssh/authorized_keys":
              ensure  => 'present',
              owner   => $sid,
              group   => $sid,
              mode    => 0744,
              source  => $authorized_keys,
              require => File["/home/${name}/.ssh"],
            }
          }
          else {
            file {"/home/${name}/.ssh/authorized_keys":
              ensure  => 'absent',
            }
          }
        }
        else {
          file {"/home/${name}/.ssh":
            ensure  => 'absent',
          }
        }
      }

      else {
        file {"/home/${name}":
          ensure => 'absent',
        }
      }
    }

    default: {
      fail("Unknown value for ensure ${ensure}")
    }
  }
}