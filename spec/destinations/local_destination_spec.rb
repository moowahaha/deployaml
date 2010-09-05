require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml')

describe Deployaml::LocalDestination do
  it "should delegate to a local destination when there is no host" do
    Deployaml::LocalDestination.should_receive(:new).with('path' => '/tmp/blah')
    Deployaml::Destination.new('path' => '/tmp/blah')
  end

  it "should copy files" do
    %w{ /tmp/local_destination_spec.tmp.a /tmp/local_destination_spec.tmp.b }.each do |file|
      FileUtils.rm(file) if File.exists?(file)
    end

    FileUtils.touch('/tmp/local_destination_spec.tmp.a')

    Deployaml::LocalDestination.new({}).copy('/tmp/local_destination_spec.tmp.a', '/tmp/local_destination_spec.tmp.b')
    File.should exist('/tmp/local_destination_spec.tmp.b')
  end

  context "shell commands" do
    before do
      @destination = Deployaml::Destination.new('path' => '/tmp/destination_spec_test_dir')
    end

    it "should return the result of the shell command" do
      @destination.exec('pwd').should == Dir.pwd + "\n"
    end

    it "should raise an exception when something does wrong" do
      lambda { @destination.exec('aslkjsdf') }.should raise_error("Error executing 'aslkjsdf'")
    end

    it "should print output to stdout" do
      $stdout.should_receive(:print).with(Dir.pwd + "\n")
      @destination.exec('pwd').should == Dir.pwd + "\n"
    end

    it "should print errors to stderr" do
      $stderr.should_receive(:print).with(/.+: aslkjsdf: command not found\n/)
      lambda { @destination.exec('aslkjsdf') }.should raise_error("Error executing 'aslkjsdf'")
    end
  end
end