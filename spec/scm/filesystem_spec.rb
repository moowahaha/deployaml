require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'scm', 'filesystem')
require File.join(File.dirname(__FILE__), 'scm_shared_spec')

describe Deployaml::Scm::Filesystem do
  it_should_behave_like "a source control system"

  before do
    @scm = Deployaml::Scm::Filesystem.new
    @example_repo = File.dirname(__FILE__) + '/../../fixtures/local_deployment_test_project/'
  end

  it "should stage a copy of the repo" do
    deployment = Deployaml::Deployment.new(
            'name' => 'harold',
            'repository' => {'path' => @example_repo},
            'destinations' => [{'path' => '/tmp/'}]
    )

    @scm.stage(deployment)

    File.should exist(deployment.staging_path + '/harold.txt')
  end
end