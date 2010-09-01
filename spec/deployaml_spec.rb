require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml do

  before do
    FileUtils.rm_r('/tmp/local_deployment_test_project_destination') if File.exists?('/tmp/local_deployment_test_project_destination')
    FileUtils.cp_r(File.dirname(__FILE__) + '/../fixtures/local_deployment_test_project', '/tmp/', :remove_destination => true)
  end

  it "should raise a meaningful exception when the deplo.yml file doesn't exist" do
    Dir.should_receive(:pwd).and_return('/xyz/')

    lambda { Deployaml::Runner.new.go! }.should raise_error('Cannot find deployment YAML file /xyz/deplo.yml')
  end

  it "should build a deployment from the deplo.yaml file" do
    YAML.should_receive(:load_file).and_return([{
            'name' => 'aa',
            'repository' => {'path' => '/tmp/local_deployment_test_project'},
            'destinations' => [
                    {
                            'path' => '/tmp/local_deployment_test_project_destination'
                    }
            ]
    }])

    Deployaml::Deployment.should_receive(:new).with({
            'name' => 'aa',
            'repository' => {'path' => '/tmp/local_deployment_test_project'},
            'destinations' => [
                    {
                            'path' => '/tmp/local_deployment_test_project_destination'
                    }
            ]
    }).and_return(nil)

    Deployaml::Runner.new.go!
  end

  context "pre install tasks" do
    it "should run specified tasks" do
      contents = rand

      YAML.should_receive(:load_file).and_return([{
              'name' => 'aa',
              'repository' => {'path' => '/tmp/local_deployment_test_project'},
              'pre_install' => [
                      {
                              'task' => 'write_string_to_file',
                              'parameters' => {
                                      'file' => 'blah.txt',
                                      'string' => contents
                              }
                      }
              ],
              'destinations' => [
                      {
                              'path' => '/tmp/local_deployment_test_project_destination'
                      }
              ]
      }])

      Deployaml::Runner.new.go!

      File.read("#{Dir.tmpdir}/deployaml/local_deployment_test_project/blah.txt").should == contents.to_s
      File.read('/tmp/local_deployment_test_project_destination/current/blah.txt').should == contents.to_s
    end

    it "should raise an error if it does not know of a pre-install task" do
      YAML.should_receive(:load_file).and_return([{
              'name' => 'aa',
              'repository' => {'path' => '/tmp/local_deployment_test_project'},
              'pre_install' => [
                      {'task' => 'moooo'}
              ],
              'destinations' => [
                      {
                              'path' => '/tmp/local_deployment_test_project_destination'
                      }
              ]
      }])

      lambda { Deployaml::Runner.new.go! }.should raise_error(/Do not know of pre_install 'moooo' for 'aa'/)
    end

  end

  context "installing" do
    it "should install to a destination from a staging path" do
      YAML.should_receive(:load_file).and_return([{
              'name' => 'aa',
              'repository' => {'path' => '/tmp/local_deployment_test_project'},
              'destinations' => [
                      {
                              'path' => '/tmp/local_deployment_test_project_destination'
                      }
              ]
      }])

      fake_destination = mock('destination')
      Deployaml::Destination.should_receive(:new).and_return(fake_destination)
      fake_destination.should_receive(:install_from).with(File.join(Dir.tmpdir, 'deployaml', 'local_deployment_test_project'))
      Deployaml::Runner.new.go!
    end
  end

end