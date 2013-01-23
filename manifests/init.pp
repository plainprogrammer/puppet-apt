# Class: apt_autoupdate
#
#   This module manages automatic updates on apt-based systems.
#
#   James Thompson <jamest@thereadyproject.com>
#   2013-01-22
#
#   Tested platforms:
#    - Ubuntu 12.04 LTS (32 & 64)
#
# Parameters:
#
#   $origins = ["${lsbdistid}:${lsbdistcodename}-security"]
#     Origins to include in unattended upgrades. By default this module will
#     include the appropriate security origin for your system. Any value set
#     for this parameter should be exhaustive, as not defaults will be
#     interpolated.
#
#   $package_blacklist = []
#     Packages to exclude from unattended upgrades.
#
#   $report_to = 'admin@example.org'
#     Email address that upgrade and apticron reports should go to.
#
#   $report_from = 'nobody@example.org',
#     Email address that upgrade and apticron reports should come from.
#
#   $download_limit = '128'
#     Download limit to impose on update process, in kb/s.
#
#   $autoupdate = false
#     Whether to update the required packages automatically.
#
#
# Actions:
#
#  Installs, configures, and manages automatic updates on apt-based systems.
#
# Requires:
#
# Sample Usage:
#
#   class { "apt_autoupdate":
#     report_to      => 'admin@example.org',
#     report_from    => 'autoupdate@example.org',
#     download_limit => '256',
#   }
#
# [Remember: No empty lines between comments and class definition]
class apt_autoupdate(
  $origins=["${::lsbdistid}:${::lsbdistcodename}-security"],
  $package_blacklist=[],
  $report_to='nobody',
  $report_from='nobody',
  $download_limit='128',
  $autoupdate=false,
  $enable=true,
  $ensure='running'
) {

  if $report_to == 'nobody' {
    fail('report_to parameter must be set to an email address')
  }

  if $report_to == 'nobody' {
    fail('report_from parameter must be set to an email address')
  }

  if $autoupdate == true {
    $package_ensure = latest
  } elsif $autoupdate == false {
    $package_ensure = present
  } else {
    fail('autoupdate parameter must be true or false')
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
      fail("The ${module_name} module is not supported on ${::osfamily} based systems")
    }
  }

  package {'unattended-upgrades':
    ensure  => $package_ensure,
  }

  package {'apticron':
    ensure  => $package_ensure,
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