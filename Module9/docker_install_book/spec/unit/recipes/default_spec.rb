#
# Cookbook:: docker_install_book
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'docker_install_book::default' do

  context 'When all attributes are default, on an Centos 7' do
  
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.5.1804')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs docker' do
      expect(chef_run).to run_bash('install_docker')
    end

    it 'installs docker compose' do
      expect(chef_run).to run_bash('install_docker_compose')
    end

    it 'starts docker' do
      expect(chef_run).to run_bash('start_docker')
    end

    it 'starts docker_registry' do
      expect(chef_run).to run_bash('start_docker_registry')
    end

  end
end
