require 'tmpdir'
require File.join(File.dirname(__FILE__), 'destination')
require File.join(File.dirname(__FILE__), 'local_destination')
require File.join(File.dirname(__FILE__), 'remote_destination')

module Deployaml
  class Deployment
    attr_reader :scm, :name, :repository_path, :staging_path, :pre_install_tasks, :post_install_tasks, :destinations

    def initialize params
      validate params

      @scm = params['repository']['scm'] || 'filesystem'
      @name = params['name']
      @repository_path = params['repository']['path']
      @pre_install_tasks = params['pre_install']
      @post_install_tasks = params['post_install']

      initialize_destinations(params)
      construct_stage
    end

    def construct_stage
      @staging_path = File.join(Dir.tmpdir, 'deployaml', File.basename(repository_path))
      FileUtils.rm_r(@staging_path) if File.directory?(@staging_path)
      FileUtils.mkdir_p(@staging_path)
    end

    private

    def initialize_destinations params
      @destinations = []

      params['destinations'].map {|d| @destinations << Deployaml::Destination.new(d)}
    end

    def validate params
      raise "Deployment has no name" unless param_specified?(params['name'])
      raise "Deployment '#{params['name']}' has no repository specified" unless param_specified?(params['repository'])
      raise "No destinations specified for '#{params['name']}'" unless param_specified?(params['destinations'])
      raise "No repository path specified for '#{params['name']}'" unless param_specified?(params['repository']['path'])
    end

    def param_specified? param
      !param.nil? && !param.empty?
    end
  end
end