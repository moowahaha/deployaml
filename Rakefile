require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/deployaml'

Hoe.plugin :newgem

$hoe = Hoe.spec 'deployaml' do
  self.developer 'Stephen Hardisty', 'moowahaha@hotmail.com'
  self.rubyforge_name = self.name
  #self.extra_deps = [['blah', '>= 0.0']]
end

require 'newgem/tasks'
Dir['tasks/*.rake'].each { |t| load t }