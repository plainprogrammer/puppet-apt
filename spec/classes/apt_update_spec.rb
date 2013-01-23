#!/usr/bin/env rspec
require 'spec_helper'

describe 'apt::update' do
  it { should contain_exec('apt-update') }
end
