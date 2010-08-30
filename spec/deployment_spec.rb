require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml::Deployment do
  context 'errors' do
    it "should always have a name" do
      lambda { Deployaml::Deployment.new({}) }.should raise_error("Deployment has no name")
    end

    it "should always have a repository" do
      lambda { Deployaml::Deployment.new({'name' => 'bob'}) }.should raise_error("Deployment 'bob' has no repository specified")
    end

    it "should always have at least one destination" do
      lambda { Deployaml::Deployment.new({'name' => 'tim', 'repository' => {'path' => '/tmp/'}}) }.should raise_error("No destinations specified for 'tim'")
    end

    it "should freak out if there is no repository path" do
      lambda { Deployaml::Deployment.new('name' => 'tim', 'repository' => {'a' => 'b'}, 'destinations' => [{'path' => '/tmp/'}]) }.should raise_error("No repository path specified for 'tim'")
    end
  end

  context 'name' do
    it "should have a name" do
      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/tmp/', 'scm' => 'git'},
              'destinations' => [{'path' => '/tmp/'}]
      )

      deployment.name.should == 'tim'
    end
  end

  context 'repository' do
    it "should return an scm" do
      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/tmp/', 'scm' => 'git'},
              'destinations' => [{'path' => '/tmp/'}]
      )

      deployment.scm.should == 'git'
    end

    it "should default the scm to filesystem if not specified" do
      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/tmp/'},
              'destinations' => [{'path' => '/tmp/'}]
      )

      deployment.scm.should == 'filesystem'
    end

    it "should have a repository path" do
      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/tmp/'},
              'destinations' => [{'path' => '/tmp/'}]
      )

      deployment.repository_path.should == '/tmp/'
    end

  end

  context "pre_install" do

    it "should have optional pre-install tasks" do
      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/tmp/'},
              'destinations' => [{'path' => '/tmp/'}],
              'pre_install' => [
                      {
                              'task' => 'harold',
                              'params' => ['a', 'b']
                      }
              ]
      )

      deployment.pre_install_tasks.length.should == 1
      deployment.pre_install_tasks.first['task'].should == 'harold'
      deployment.pre_install_tasks.first['params'].should == ['a', 'b']
    end

  end

  context 'staging' do
    it "should have a staging root" do
      FileUtils.rm_r('/tmp/deployaml') if File.exists?('/tmp/deployaml')

      Dir.should_receive(:tmpdir).and_return('/tmp/')

      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/xyz/bobberoo'},
              'destinations' => [{'path' => '/tmp/'}]
      )

      deployment.staging_path.should == '/tmp/deployaml/bobberoo'
      File.directory?('/tmp/deployaml/bobberoo').should be_true
    end
  end

  context 'destinations' do
    it "should construct an instance of a destination" do
      first_destination = mock('first destination')
      second_destination = mock('second destination')

      Deployaml::Destination.should_receive(:new).once.with('path' => '/tmp/a/').and_return(first_destination)
      Deployaml::Destination.should_receive(:new).once.with('path' => '/tmp/b/').and_return(second_destination)


      deployment = Deployaml::Deployment.new(
              'name' => 'tim',
              'repository' => {'path' => '/tmp/'},
              'destinations' => [
                      {'path' => '/tmp/a/'},
                      {'path' => '/tmp/b/'}
              ]
      )

      deployment.destinations.length.should == 2
      deployment.destinations.first.should == first_destination
      deployment.destinations.last.should == second_destination
    end
  end
end