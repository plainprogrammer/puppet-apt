# Class: apt::params
#
#   The Apt module's configuration settings.
#
class apt::params(
  $origins            = [ ],
  $package_blacklist  = [ ],
  $report_to          = undef,
  $report_from        = undef,
  $download_limit     = '128',
  $use_latest         = false
) {
  if $report_to == undef {
    fail('report_to parameter must be set to an email address')
  }

  if $report_to == undef {
    fail('report_from parameter must be set to an email address')
  }

  if $use_latest == true {
    $package_ensure = latest
  } elsif $use_latest == false {
    $package_ensure = present
  } else {
    fail('use_latest parameter must be true or false')
  }

}
