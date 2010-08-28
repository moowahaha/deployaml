require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'scm', 'filesystem')
require File.join(File.dirname(__FILE__), 'scm_shared_spec')

describe Deployaml::Scm::Filesystem do
  it_should_behave_like "a source control system"

  before do
    @scm = Deployaml::Scm::Filesystem.new
    @example_repo = File.dirname(__FILE__) + '/../../fixtures/local_deployment_test_project/'
  end

  it "should stage a copy of the repo" do
    FileUtils.rm_r("/tmp/dick") if File.exist?("/tmp/dick")
    FileUtils.mkdir('/tmp/dick')

    @scm.stage(@example_repo, '/tmp/dick')

    File.should exist(@example_repo + '/harold.txt')
  end
end