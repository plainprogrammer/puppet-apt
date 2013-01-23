# Class: apt::update
#
#   Class that simply runs apt-get update.
#
# Usage:
#
#   include apt::update
#
class apt::update() {
  exec {'apt-update':
    command => '/usr/bin/apt-get update -y -qq'
  }
}
