#!/usr/bin/env rspec
require 'spec_helper'

describe 'apt' do
  let(:required_params) { { :report_to => 'nobody@example.org', :report_from => 'nobody@example.org' } }

  let(:params) { required_params.merge({}) }
  let(:facts) { { :osfamily => 'debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'precise' } }

  it { should include_class('apt::params') }

  it { should contain_package('unattended-upgrades').with_ensure('present') }
  it { should contain_package('apticron').with_ensure('present') }

  describe 'with autoupdate option set to true' do
    let(:params) { required_params.merge({ :use_latest => true }) }

    it { should contain_package('unattended-upgrades').with_ensure('latest') }
    it { should contain_package('apticron').with_ensure('latest') }
  end

  describe 'for operating system family unsupported' do
    let(:facts) { { :osfamily  => 'unsupported' } }

    it { expect{ subject }.to raise_error(/^The apt module is not supported on unsupported based systems/)}
  end

  describe 'managing /etc/apt/apt.conf.d/10periodic' do
    let(:content) { param_value(subject, 'file', '/etc/apt/apt.conf.d/10periodic', 'content') }

    it { should contain_file('/etc/apt/apt.conf.d/10periodic').with_owner('0') }
    it { should contain_file('/etc/apt/apt.conf.d/10periodic').with_group('0') }
    it { should contain_file('/etc/apt/apt.conf.d/10periodic').with_mode('0644') }
  end

  describe 'managing /etc/apt/apt.conf.d/50unattended-upgrades' do
    let(:content) { param_value(subject, 'file', '/etc/apt/apt.conf.d/50unattended-upgrades', 'content') }

    it { should contain_file('/etc/apt/apt.conf.d/50unattended-upgrades').with_owner('0') }
    it { should contain_file('/etc/apt/apt.conf.d/50unattended-upgrades').with_group('0') }
    it { should contain_file('/etc/apt/apt.conf.d/50unattended-upgrades').with_mode('0644') }

    it { content.should match_regex(/Unattended-Upgrade::Mail\s+"nobody@example\.org";/) }

    describe 'setting download limit' do
      let(:params) { required_params.merge({ :download_limit => '256' }) }

      it { content.should match_regex(/Acquire::http::Dl-Limit\s+"256";/) }
    end

    describe 'manages allowed origins' do
      let(:params) { required_params.merge({ :origins => ['${lsbdistid}:${lsbdistcodename}-security'] }) }

      it { content.should match_regex(/Unattended-Upgrade::Allowed-Origins \{\s+"Ubuntu:precise-security";\s+\};/) }
    end

    describe 'manages package blacklist' do
      let(:params) { required_params.merge({ :package_blacklist => ['nginx'] }) }

      it { content.should match_regex(/Unattended-Upgrade::Package-Blacklist \{\s+"nginx";\s+\};/) }
    end
  end

  describe 'managing /etc/apticron/apticron.conf' do
    let(:content) { param_value(subject, 'file', '/etc/apticron/apticron.conf', 'content') }

    it { should contain_file('/etc/apticron/apticron.conf').with_owner('0') }
    it { should contain_file('/etc/apticron/apticron.conf').with_group('0') }
    it { should contain_file('/etc/apticron/apticron.conf').with_mode('0644') }

    it { content.should match_regex(/EMAIL\s+ = "nobody@example\.org"/) }
    it { content.should match_regex(/CUSTOM_FROM\s+ = "nobody@example\.org"/) }
  end
end
