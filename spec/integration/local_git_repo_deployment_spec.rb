require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml')
require 'git'

describe Deployaml do
  context "local git deployment" do
    before(:all) do
      %w{/tmp/local_git_test_project_repo}.each do |dir|
        FileUtils.rm_r(dir) if File.exists?(dir)
      end

      FileUtils.cp_r(File.dirname(__FILE__) + '/../../fixtures/local_git_deployment_test_repo/', '/tmp/', :remove_destination => true)
      FileUtils.cd(File.dirname(__FILE__) + '/../../fixtures/local_git_deployment_test_project/')

      fake_now = 'current time'
      Time.should_receive(:now).and_return(fake_now)
      fake_now.should_receive(:strftime).with('%Y%M%d%H%M%S').and_return '20105726195752'

      Deployaml::Runner.new.go!
    end

    it "should copy the archive of the repo" do
      File.should exist("/tmp/local_git_deployment_test_project_destination/releases/20105726195752/benjamin.txt")
    end

    it "should symlink to the release" do
      File.symlink?("/tmp/local_git_deployment_test_project_destination/current").should be_true
      File.should exist("/tmp/local_git_deployment_test_project_destination/current/benjamin.txt")
    end

    it "should be an archived git repo (i.e. not a real one)" do
      lambda {Git.open("/tmp/local_git_deployment_test_project_destination/current")}.should raise_error(/path does not exist/)
    end
  end
end