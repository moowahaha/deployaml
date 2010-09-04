require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml::RemoteDestination do
  it "should have a path" do
    Deployaml::RemoteDestination.new(
            {
                    'path' => '/tmp/blah'
            }.merge(
                    YAML.load_file(File.dirname(__FILE__) + '/../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml')
            )
    ).path.should == '/tmp/blah'
  end

  it "should throw a wobbler when no host is supplied" do
    lambda { Deployaml::RemoteDestination.new({}) }.should raise_error('A remote host must be specified')
  end

  it "should delegate to a remote destination when there is a host" do
    Deployaml::RemoteDestination.should_receive(:new).with(
            'path' => '/tmp/blah',
            'host' => 'blah.com'
    )

    Deployaml::Destination.new(
            'path' => '/tmp/blah',
            'host' => 'blah.com'
    )
  end

  it "should open an ssh session on a remote host" do
    remote = YAML.load_file(File.dirname(__FILE__) + '/../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml')

    destination = Deployaml::Destination.new(
            {
                    'path' => '/tmp/blah'
            }.merge(remote)
    )

    destination.exec('whoami').should == remote['username'] + "\n"
  end

#    context "installing" do
#      before do
#        @destination_dir = '/tmp/destination_spec_test_dir'
#        FileUtils.rm_r(@destination_dir) if File.exists?(@destination_dir)
#
#        fake_time = mock('time')
#        Time.should_receive(:now).and_return(fake_time)
#        fake_time.should_receive(:strftime).with('%Y%M%d%H%M%S').and_return('20100901200900')
#
#        destination = Deployaml::Destination.new('path' => @destination_dir)
#        destination.install_from "#{File.dirname(__FILE__)}/../fixtures/local_deployment_test_project"
#      end
#
#      it "should copy a staging directory to a release directory" do
#        File.should be_directory("/tmp/destination_spec_test_dir/releases/20100901200900")
#        File.should exist("/tmp/destination_spec_test_dir/releases/20100901200900/harold.txt")
#      end
#
#      it "should symlink the current runner to the spanking new release" do
#        File.should be_symlink("/tmp/destination_spec_test_dir/current")
#        File.should exist("/tmp/destination_spec_test_dir/current/harold.txt")
#      end
#    end

  context "shell commands" do
    before(:all) do
      @remote = YAML.load_file(
              File.dirname(__FILE__) + '/../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml'
      )

      @destination = Deployaml::Destination.new(
              {
                      'path' => '/tmp/blah'
              }.merge(@remote)
      )
    end

    it "should return the result of the shell command" do
      @destination.exec('hostname').should_not == `hostname`
    end

    it "should raise an exception when something does wrong" do
      lambda { @destination.exec('aslkjsdf') }.should raise_error("Error executing 'aslkjsdf'")
    end

    it "should print output to stdout" do
      $stdout.should_receive(:print).with(@remote['username'] + "\n")
      @destination.exec('whoami').should == @remote['username'] + "\n"
    end

    it "should print errors to stderr" do
      $stderr.should_receive(:print).with(/.+: aslkjsdf: command not found\n/)
      lambda { @destination.exec('aslkjsdf') }.should raise_error("Error executing 'aslkjsdf'")
    end
  end
end