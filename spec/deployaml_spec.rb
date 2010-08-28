require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml do

  context 'errors' do

    before do
      FileUtils.touch('deplo.yml')
    end

    it "should raise a meaningful exception when the deplo.yml file doesn't exist" do
      Dir.should_receive(:pwd).and_return('/xyz/')

      lambda { Deployaml::Runner.go! }.should raise_error('Cannot find deployment YAML file /xyz/deplo.yml')
    end

    it "should raise an angry exception when no name is specified for a deployment" do
      YAML.should_receive(:load_file).and_return([{}])

      lambda { Deployaml::Runner.go! }.should raise_error('Deployment has no name')
    end

    it "should raise a powerful objection to a nonexistent repository" do
      YAML.should_receive(:load_file).and_return([{'name' => 'aa', 'repository' => {'path' => '/xyz/blah'}}])

      lambda { Deployaml::Runner.go! }.should raise_error('Cannot read repository /xyz/blah')
    end

  end

end