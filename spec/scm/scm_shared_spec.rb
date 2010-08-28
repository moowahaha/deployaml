shared_examples_for "a source control system" do
  it "should throw an exception on an unretrievable repo" do
    lambda { @scm.stage('/xyz/blah', '/tmp/') }.should raise_error('Cannot read repository /xyz/blah')
  end

  it "should throw an exception on a non existant staging directory" do
    lambda { @scm.stage('/tmp/', '/xyz/blah') }.should raise_error('Cannot find staging directory /xyz/blah')
  end

  it "should remove its deplo.yml from the staged version" do
    stage_dest = '/tmp/blah'
    FileUtils.rm_r(stage_dest) if File.exists?(stage_dest)
    FileUtils.mkdir(stage_dest)
    @scm.stage(@example_repo, stage_dest)

    File.should_not exist(File.join(stage_dest, File.basename(@example_repo), 'deplo.yml'))
  end
end