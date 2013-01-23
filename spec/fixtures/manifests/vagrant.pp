class { 'apt':
  report_to   => 'nobody@example.org',
  report_from => 'nobody@example.org',
  use_latest  => true,
}