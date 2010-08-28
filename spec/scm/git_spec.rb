require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'scm', 'git')
require File.join(File.dirname(__FILE__), 'scm_shared_spec')

describe Deployaml::Scm::Git do
  it_should_behave_like "a source control system"

  before do
    @scm = Deployaml::Scm::Git.new
    @example_repo = File.dirname(__FILE__) + '/../../fixtures/local_git_deployment_test_repo'
  end

  it "should clone a git repo" do
    FileUtils.rm_r("/tmp/harry") if File.exist?("/tmp/harry")
    FileUtils.mkdir('/tmp/harry')

    @scm.stage(@example_repo, '/tmp/harry')

    File.should exist('/tmp/harry/local_git_deployment_test_repo/benjamin.txt')
    File.should_not exist('/tmp/harry/local_git_deployment_test_repo/.git/')
  end
end