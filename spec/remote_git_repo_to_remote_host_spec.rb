require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml do
  before(:all) do
        destination_host = YAML.load_file(
            File.dirname(__FILE__) + '/../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml'
    )

    fake_time = mock('time')
    Time.stub(:now).and_return(fake_time)
    fake_time.stub(:strftime).with('%Y%M%d%H%M%S').and_return('20100901200900')

    YAML.should_receive(:load_file).and_return([{
            'name' => 'remote to remote',
            'repository' => {
                    'path' => 'http://github.com/moowahaha/deployaml.git',
                    'scm' => 'git'
            },
            'destinations' => [
                    {
                            'path' => '/tmp/test_deployment'
                    }.merge(destination_host)
            ]
    }])

    @session = Net::SSH.start(destination_host['host'], destination_host['username'])
    @session.exec!('rm -fr /tmp/test_deployment')

    Deployaml::Runner.new.go!
  end

  it "should deploy to a timestamped destination" do
    @session.exec!('file /tmp/test_deployment/releases/20100901200900/README.rdoc').should =~ /ASCII English text/
  end

  it "should have a current symlink to the destination" do
    @session.exec!('file /tmp/test_deployment/current/README.rdoc').should =~ /ASCII English text/
  end
end