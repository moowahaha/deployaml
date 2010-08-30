require File.dirname(__FILE__) + '/../../lib/deployaml/deployment'

shared_examples_for "a source control system" do
  it "should throw an exception on an unretrievable repo" do
    deployment = Deployaml::Deployment.new(
            'name' => 'harold',
            'repository' => {'path' => '/xyz/blah'},
            'destinations' => [{'path' => '/tmp/'}]
    )

    lambda { @scm.stage(deployment) }.should raise_error("Cannot read repository /xyz/blah for 'harold'")
  end

  it "should remove its deplo.yml from the staged version" do
    deployment = Deployaml::Deployment.new(
            'name' => 'harold',
            'repository' => {'path' => @example_repo},
            'destinations' => [{'path' => '/tmp/'}]
    )

    @scm.stage(deployment)

    File.should_not exist(File.join(deployment.staging_path, File.basename(@example_repo), 'deplo.yml'))
  end
end