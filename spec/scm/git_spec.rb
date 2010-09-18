require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'scm', 'git')
require File.join(File.dirname(__FILE__), 'scm_shared_spec')

describe Deployaml::Scm::Git do
  it_should_behave_like "a source control system"

  before do
    @scm = Deployaml::Scm::Git.new
    @example_repo = File.dirname(__FILE__) + '/../../fixtures/local_git_deployment_test_repo'
  end

  it "should clone a git repo" do
    deployment = Deployaml::Deployment.new(
            'name' => 'harold',
            'repository' => {'path' => @example_repo},
            'destinations' => [{'path' => '/tmp/'}]
    )

    @scm.stage(deployment)

    File.should exist(deployment.staging_path + '/benjamin.txt')
    File.should_not exist(deployment.staging_path + '/.git/')
  end

  it "should clone a particular version of a git repo" do
    deployment = Deployaml::Deployment.new(
            'name' => 'harold',
            'repository' => {'path' => @example_repo},
            'destinations' => [{'path' => '/tmp/'}]
    )

    @scm.stage(deployment, 'with_bob_instead_of_benjamin')

    File.should exist(deployment.staging_path + '/bob.txt')
    File.should_not exist(deployment.staging_path + '/benjamin.txt')        
  end
end