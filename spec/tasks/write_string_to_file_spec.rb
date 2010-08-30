require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'deployment')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'pre_install', 'write_string_to_file')

describe Deployaml::PreInstall::WriteStringToFile do
  it "should write a string to a file (easy)" do
    deployment = Deployaml::Deployment.new(
            'name' => 'tim',
            'repository' => {'path' => '/tmp/'},
            'destinations' => [{'path' => '/tmp/'}],
            'pre_install' => [
                    {
                            'task' => 'write_sting_to_file',
                            'params' => 'whatever'
                    }
            ]
    )

    Deployaml::PreInstall::WriteStringToFile.new.run(
            deployment,
            {
                    'file' => 'moomin',
                    'string' => 'hello'
            }
    )

    File.read('/tmp/moomin').should == 'hello'
  end
end