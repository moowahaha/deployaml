require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml')
require 'date'

describe Deployaml do
  context "local filesystem deployment" do
    before(:all) do
      FileUtils.rm_r('/tmp/local_deployment_test_project_destination') if File.exists?('/tmp/local_deployment_test_project_destination')
      FileUtils.cp_r(File.dirname(__FILE__) + '/../../fixtures/local_deployment_test_project', '/tmp/', :remove_destination => true)

      FileUtils.cd(File.dirname(__FILE__) + '/../../fixtures/local_deployment_test_project')

      fake_now = Date.strptime('20101226195752', '%Y%m%d%H%M%S').to_time
      Time.should_receive(:now).any_number_of_times.and_return(fake_now)
      fake_now.should_receive(:strftime).with('%Y%m%d%H%M%S').and_return '20101226195752'

      Deployaml::Runner.new.go!
    end

    it "should copy the archive of the git repo" do
      File.should exist("/tmp/local_deployment_test_project_destination/releases/20101226195752/harold.txt")
    end

    it "should symlink to the release" do
      File.symlink?("/tmp/local_deployment_test_project_destination/current").should be_true
      File.should exist("/tmp/local_deployment_test_project_destination/current/harold.txt")
    end
  end
end