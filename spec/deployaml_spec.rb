require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml do

  context 'errors' do

    before do
      FileUtils.touch('deplo.yml')
    end

    it "should raise a meaningful exception when the deplo.yml file doesn't exist" do
      Dir.should_receive(:pwd).and_return('/xyz/')

      lambda { Deployaml.go! }.should raise_error('Cannot find deployment YAML file /xyz/deplo.yml')
    end

    it "should raise a powerful objection to a nonexistent repository" do
      YAML.should_receive(:load_file).and_return([{'repository' => {'path' => '/xyz/blah'}}])

      lambda { Deployaml.go! }.should raise_error('Cannot find repository /xyz/blah')
    end

  end

end