# Class: apt
#
#   This class allows for the management of various Apt related features,
#   including managing unattended-updates and apticron.
#
# Parameters:
#
#  [*origins*] - Origins to include in unattended upgrades. By default this
#                module will include the appropriate security origin for your
#                system. Any value set for this parameter should be exhaustive,
#                as not defaults will be interpolated.
#
#  [*package_blacklist*] - Packages to exclude from unattended upgrades.
#
#  [*report_to*] - Email address that upgrade and apticron reports should go
#                  to.
#
#  [*report_from*] - Email address that upgrade and apticron reports should
#                    come from.
#
#  [*download_limit*] - Download limit to impose on update process, in kb/s.
#
#  [*use_latest*] - Whether to update the required packages automatically.
#
# Sample Usage:
#
#   class { 'apt':
#     report_to      => 'admin@example.org',
#     report_from    => 'autoupdate@example.org',
#     download_limit => '256',
#   }
#
class apt(
  $origins            = undef,
  $package_blacklist  = undef,
  $report_to          = undef,
  $report_from        = undef,
  $download_limit     = undef,
  $use_latest         = undef
) {

  class { 'apt::params':
    origins           => $origins,
    package_blacklist => $package_blacklist,
    report_to         => $report_to,
    report_from       => $report_from,
    download_limit    => $download_limit,
    use_latest        => $use_latest
  }

  case $::osfamily {
    Debian: {
      $supported              = true
      $periodic_config        = '/etc/apt/apt.conf.d/10periodic'
      $periodic_config_tpl    = 'periodic.erb'
      $unattended_config      = '/etc/apt/apt.conf.d/50unattended-upgrades'
      $unattended_config_tpl  = 'unattended.erb'
      $apticron_config        = '/etc/apticron/apticron.conf'
      $apticron_config_tpl    = 'apticron.conf.erb'
    }
    default: {
      fail("The apt module is not supported on ${::osfamily} based systems")
    }
  }

  package {'unattended-upgrades':
    ensure  => $apt::params::package_ensure,
  }

  package {'apticron':
    ensure  => $apt::params::package_ensure,
  }

  file { $periodic_config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${periodic_config_tpl}"),
    require => Package[unattended-upgrades],
  }

  file { $unattended_config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${unattended_config_tpl}"),
    require => Package[unattended-upgrades],
  }

  file { $apticron_config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/${apticron_config_tpl}"),
    require => Package[apticron],
  }
}