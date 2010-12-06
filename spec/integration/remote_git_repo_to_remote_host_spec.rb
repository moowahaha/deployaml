require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml')

describe Deployaml do
  before(:all) do
        destination_host = YAML.load_file(
            File.dirname(__FILE__) + '/../../stuff_not_to_be_committed/host_and_username_with_ssh_keys.yml'
    )

    fake_now = Date.strptime('20101226195752', '%Y%m%d%H%M%S').to_time
    Time.should_receive(:now).any_number_of_times.and_return(fake_now)
    fake_now.should_receive(:strftime).with('%Y%m%d%H%M%S').and_return '20101226195752'

    YAML.should_receive(:load_file).and_return([{
            'name' => 'remote to remote',
            'repository' => {
                    'path' => 'http://github.com/moowahaha/tennis_kata_no_ifs.git',
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
    @session.exec!('file /tmp/test_deployment/releases/20101226195752/README').should =~ /ASCII English text/
  end

  it "should have a current symlink to the destination" do
    @session.exec!('file /tmp/test_deployment/current/README').should =~ /ASCII English text/
  end
end