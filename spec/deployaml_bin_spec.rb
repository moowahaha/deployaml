EXECUTABLE = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'bin', 'deployaml')

def run argument_string
  `#{EXECUTABLE} #{argument_string} 2>&1`
end

describe 'executable' do
  it "should show help" do
    run('--help').should =~ /deploys your project/
  end

  it "should list available scms" do
    output = run('--scms')
    output.should =~ /All scms:/
    output.should =~ /\tgit\n/
  end

  it "should list available tasks" do
    output = run('--tasks')
    output.should =~ /All pre_install:/
    output.should =~ /\tminify\n/
    output.should =~ /All post_install:/
    output.should =~ /\tpending_migrations\n/
  end

  it "should list available deployments" do
    Dir.chdir(File.join(File.dirname(__FILE__), '..', 'fixtures', 'executable_test_project')) do
      output = run('--deployments')
      output.should =~ /Available deployments:/
      output.should =~ /\tfirst \(from git\)\n/
      output.should =~ /\tsecond \(from filesystem\)\n/
    end
  end

  it "should load custom handlers from a specified path" do
    output = run("--tasks --include #{File.dirname(__FILE__) + '/../fixtures/custom_handlers'}")
    output.should =~ /\texplode\n/
    output.should =~ /\tfizzle\n/
  end
end