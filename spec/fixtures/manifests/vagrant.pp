class { 'apt_autoupdate':
  report_to   => 'nobody@example.org',
  report_from => 'nobody@example.org',
  autoupdate  => true,
}