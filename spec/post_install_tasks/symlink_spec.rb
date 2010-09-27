require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'deployment')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'post_install', 'symlink')

describe Deployaml::PostInstall::Symlink do
  before do
    FileUtils.rm_r('/tmp/symlink_test') if File.exists?('/tmp/symlink_test')
    FileUtils.mkdir_p('/tmp/symlink_test/current')
    FileUtils.touch('/tmp/symlink_test/current/to_overwrite')

    File.open('/tmp/dest1', 'w') { |fh| fh.print('1') }
    File.open('/tmp/dest2', 'w') { |fh| fh.print('2') }

    @deployment = Deployaml::Deployment.new(
            'name' => 'tim',
            'repository' => {'path' => '/tmp/symlink_test_repo'},
            'destinations' => [{'path' => '/tmp/symlink_test'}]
    )

    @destination = Deployaml::Destination.new('path' => '/tmp/symlink_test')
  end

  it "should create symlinks" do
    Deployaml::PostInstall::Symlink.new.run(
            @deployment,
            @destination,
            [
                    {
                            'source' => '/tmp/dest1',
                            'target' => 'to_overwrite'
                    },
                    {
                            'source' => '/tmp/dest2',
                            'target' => 'to_create'
                    }
            ]
    )

    File.should be_symlink("/tmp/symlink_test/current/to_overwrite")
    File.open('/tmp/symlink_test/current/to_overwrite', 'r').read.should == '1'

    File.should be_symlink("/tmp/symlink_test/current/to_create")
    File.open('/tmp/symlink_test/current/to_create', 'r').read.should == '2'
  end

  it "should raise an error if a source isn't specified" do
    lambda { Deployaml::PostInstall::Symlink.new.run(
            @deployment,
            @destination,
            [
                    {
                            'target' => 'some_target'
                    }
            ]
    ) }.should raise_error('source not specified for symlink')
  end

  it "should raise an error if a target isn't specified" do
    lambda { Deployaml::PostInstall::Symlink.new.run(
            @deployment,
            @destination,
            [
                    {
                            'source' => 'some_source'
                    }
            ]
    ) }.should raise_error('target not specified for symlink')
  end
end