Apt
===

[![Build Status](https://travis-ci.org/plainprogrammer/puppet-apt.png)](https://travis-ci.org/plainprogrammer/puppet-apt)

A module to manage automatic updates for Apt-based systems.

Platforms
---------

The following target operating systems have been tested with this module:

* Ubuntu 12.04 (32 & 64)

The following versions of Puppet have been tested with this module:

* Puppet 3.0.2
* Puppet 2.7.20
* Puppet 2.6.17

Requirements
------------

This module has no external dependencies.

Installation
------------

puppet module install plainprogrammer/apt

Usage
-----

    class { 'apt':
        report_to      => 'admin@example.org',
        report_from    => 'autoupdate@example.org',
        download_limit => '256',
    }

Contributing
------------

Contributing is easy, unless you're lazy.

1. Create an Issue and get feedback
2. Fork the project
3. Branch and develop with tests
4. Submit a Pull Request

It is very important that your changes be tested, both via RSpec test and in reality by running via Vagrant. It is also
very important that you don't try and code-fist the project. Keep your development focused on one particular feature or
bug. Small and focused sets of changes are easier to accept as Pull Requests.
