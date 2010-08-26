require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml do
  before do
    FileUtils.rm_r('/tmp/basic_test_project_destination') if File.exists?(File.dirname(__FILE__) + '/basic_test_project_destination')
    FileUtils.cp_r(File.dirname(__FILE__) + '/basic_test_project', '/tmp/', :remove_destination => true)
    FileUtils.cd(File.dirname(__FILE__) + '/basic_test_project')

    fake_now = 'current time'
    Time.should_receive(:now).and_return(fake_now)
    fake_now.should_receive(:strftime).with('%Y%M%d%H%M%S').and_return '20105726195752'

    Deployaml.go!
  end

  it "should copy the source into the releases directory" do
    File.should exist("/tmp/basic_test_project_destination/releases/20105726195752/harold.txt")
  end

  it "should symlink to the release" do
    File.symlink?("/tmp/basic_test_project_destination/current").should be_true
    File.should exist("/tmp/basic_test_project_destination/current/harold.txt")
  end
end