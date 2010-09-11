require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'deployment')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'post_install', 'restart_passenger')

describe Deployaml::PostInstall::RestartPassenger do
  it "should touch tmp/restart.txt" do
    FileUtils.rm_r('/tmp/passenger_test') if File.exists?('/tmp/passenger_test')
    FileUtils.mkdir_p('/tmp/passenger_test')

    deployment = Deployaml::Deployment.new(
            'name' => 'tim',
            'repository' => {'path' => '/tmp/passenger_test_repo'},
            'destinations' => [{'path' => '/tmp/passenger_test'}],
            'post_install' => [
                    {
                            'task' => 'restart_passenger'
                    }
            ]
    )

    destination = Deployaml::Destination.new('path' => '/tmp/passenger_test')

    Deployaml::PostInstall::RestartPassenger.new.run(deployment, destination, {})

    File.should exist("/tmp/passenger_test/current/tmp/restart.txt")
  end
end