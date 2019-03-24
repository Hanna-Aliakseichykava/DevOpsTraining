# # encoding: utf-8

# Inspec test for recipe docker_install_book::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/



describe package('yum-utils') do
  it { should be_installed }
end

describe package('docker-ce') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end


describe file('/usr/bin/docker-compose') do
  it { should exist }
end

describe file('/etc/docker/daemon.json') do
  its('content') { should match(%r{{ "insecure-registries" : ["localhost:5000" ] }}) }
end

describe port(5000), :skip do
  it { should be_listening }
end