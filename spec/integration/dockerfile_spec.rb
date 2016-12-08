require 'spec_helper'

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :os, family: :alpine
    set :backend, :docker
    set :docker_image, image.id
  end

  describe file('/usr/local/bin/service') do
    it { should exist }
  end

  describe file('/usr/local/bin/entrypoint') do
    it { should exist }
  end

  describe package('xmlstarlet'), :if => os[:family] == 'alpine' do
    it { should be_installed }
  end

  describe file('/opt/atlassian/jira') do
    it { should be_directory }
  end

  describe file('/var/opt/atlassian/application-data/jira') do
    it { should be_directory }
  end

  describe command('ls /var/opt/atlassian/application-data/jira') do
    its(:exit_status) { should eq 0 }
  end

end
