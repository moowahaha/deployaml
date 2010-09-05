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

  it "should delegate file movements" do
    fake_time = mock('time')
    Time.stub(:now).and_return(fake_time)
    fake_time.stub(:strftime).with('%Y%M%d%H%M%S').and_return('20100901200900')

    fake_destination = mock('destination')
    Deployaml::LocalDestination.stub(:new).and_return(fake_destination)
    fake_destination.stub(:execute_and_verify).and_return([false, 'cool'])
    fake_destination.should_receive(:copy).with("/tmp/blah", "/tmp/blah/releases/20100901200900")

    Deployaml::Destination.new('path' => '/tmp/blah').install_from('/tmp/blah')
  end

  context "installing" do
    before do
      @destination_dir = '/tmp/destination_spec_test_dir'
      FileUtils.rm_r(@destination_dir) if File.exists?(@destination_dir)

      fake_time = mock('time')
      Time.should_receive(:now).and_return(fake_time)
      fake_time.should_receive(:strftime).with('%Y%M%d%H%M%S').and_return('20100901200900')

      destination = Deployaml::Destination.new('path' => @destination_dir)
      destination.install_from "#{File.dirname(__FILE__)}/../fixtures/local_deployment_test_project"
    end

    it "should copy a staging directory to a release directory" do
      File.should be_directory("/tmp/destination_spec_test_dir/releases/20100901200900")
      File.should exist("/tmp/destination_spec_test_dir/releases/20100901200900/harold.txt")
    end

    it "should symlink the current runner to the spanking new release" do
      File.should be_symlink("/tmp/destination_spec_test_dir/current")
      File.should exist("/tmp/destination_spec_test_dir/current/harold.txt")
    end
  end
end