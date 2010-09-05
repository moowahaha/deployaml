require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'deployment')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'deployaml', 'pre_install', 'minify')

describe Deployaml::PreInstall::Minify do
  before(:all) do
    FileUtils.rm_r('/tmp/minify_test') if File.exists?('/tmp/minify_test')
    FileUtils.mkdir('/tmp/minify_test')

    deployment = Deployaml::Deployment.new(
            'name' => 'tim',
            'repository' => {'path' => '/tmp/minify_test'},
            'destinations' => [{'path' => '/tmp/'}],
            'pre_install' => [
                    {
                            'task' => 'minify'
                    }
            ]
    )

    File.open("#{Dir.tmpdir}/deployaml/minify_test/sample.js", 'w') do |fh|
      fh.print "\n   alert('a');   \n"
    end

    File.open("#{Dir.tmpdir}/deployaml/minify_test/sample.css", 'w') do |fh|
      fh.print "
      a {
        color: black
      }
      "
    end

    File.open("#{Dir.tmpdir}/deployaml/minify_test/something_else.txt", 'w') do |fh|
      fh.print "\n   blah   \n"
    end

    Deployaml::PreInstall::Minify.new.run(deployment, {})
  end

  it "should minify javascript" do
    File.read("#{Dir.tmpdir}/deployaml/minify_test/sample.js").should == 'alert("a");'
  end

  it "should minify css" do
    File.read("#{Dir.tmpdir}/deployaml/minify_test/sample.css").should == "a{color:black;}"
  end

  it "should ignore non-css/js files" do
    File.read("#{Dir.tmpdir}/deployaml/minify_test/something_else.txt").should == "\n   blah   \n"
  end
end