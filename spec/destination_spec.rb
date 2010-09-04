require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml::Destination do
  it "should throw a wobbler when no path is specified" do
    lambda { Deployaml::Destination.new({}) }.should raise_error('A destination path must be specified')
  end

  it "should have a path" do
    Deployaml::Destination.new('path' => '/tmp/blah').path.should == '/tmp/blah'
  end

  it "should delegate shell executions" do
    fake_destination = mock('destination')
    Deployaml::LocalDestination.stub(:new).and_return(fake_destination)
    fake_destination.should_receive(:execute_and_verify).with('command', / && echo .+/, anything)

    Deployaml::Destination.new('path' => '/tmp/blah').exec('command')
  end

  it "should delegate installations" do
    fake_destination = mock('destination')
    Deployaml::LocalDestination.stub(:new).and_return(fake_destination)
    fake_destination.should_receive(:install_from).with('/bob')

    Deployaml::Destination.new('path' => '/tmp/blah').install_from('/bob')
  end
end