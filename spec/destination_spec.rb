require File.join(File.dirname(__FILE__), '..', 'lib', 'deployaml')

describe Deployaml::Destination do
  context 'errors' do
    it "should throw a wobbler when no path is specified" do
      lambda {Deployaml::Destination.new({})}.should raise_error('A destination path must be specified')
    end
  end

  it "should have a path" do
    Deployaml::Destination.new('path' => '/tmp/blah').path.should == '/tmp/blah'
  end
end