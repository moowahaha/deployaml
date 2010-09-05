require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml')

describe Deployaml::RemoteDestination do
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
    remote = YAML.load_file(File.dirname(__FILE__) + '/../../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml')

    destination = Deployaml::Destination.new(
            {
                    'path' => '/tmp/blah'
            }.merge(remote)
    )

    destination.exec('whoami').should == remote['username'] + "\n"
  end

  it "should copy files" do
    remote = YAML.load_file(File.dirname(__FILE__) + '/../../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml')
    session = Net::SSH.start(remote['host'], remote['username'])

    %w{  /tmp/local_destination_spec.tmp.a /tmp/local_destination_spec.tmp.b  }.each do |file|
      session.exec!("rm -fr #{file}")
    end

    session.exec('touch /tmp/local_destination_spec.tmp.a')

    Deployaml::RemoteDestination.new(remote).copy('/tmp/local_destination_spec.tmp.a', '/tmp/local_destination_spec.tmp.b')
    session.exec!('file /tmp/local_destination_spec.tmp.b').should =~ /empty/
  end

  context "shell commands" do
    before(:all) do
      @remote = YAML.load_file(
              File.dirname(__FILE__) + '/../../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml'
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