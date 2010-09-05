require 'fileutils'

Dir.glob(File.join(File.dirname(__FILE__), 'deployaml', '**', '*.rb')).each do |file|
  require file
end

module Deployaml
  class Runner
    VERSION = '0.0'

    def initialize
      load_scm
      load_pre_install_tasks
    end

    def all_scms
      @scms.keys.sort
    end

    def all_pre_install
      @pre_install.keys.sort
    end

    def go!
      deployments.each do |deployment|
        puts "Deploying #{deployment.name}"
        scm = concrete_scm(deployment)
        scm.stage(deployment)

        run_pre_install_tasks(deployment)

        deployment.destinations.each do |destination|
          destination.install_from deployment.staging_path
        end
      end
    end

    private

    def children_of constant
      classes = {}

      Deployaml.const_get(constant).constants.each do |scm|
        underscore_name = scm.gsub(/[A-Z]/) {|x| '_' + x.downcase}.gsub(/^_/, '')
        classes[underscore_name] = Deployaml.const_get(constant).const_get(scm).new
      end

      classes
    end

    def find_class_from_collection collection, nice_collection_type, nice_class, deployment
      klass = collection.find {|x| x[0] == nice_class}
      
      return klass[1] if klass

      raise "Do not know of #{nice_collection_type} '#{nice_class}' for '#{deployment.name}'. Available: #{collection.keys.sort.join(', ')}"
    end

    def concrete_scm deployment
      find_class_from_collection(@scms, 'scm', deployment.scm, deployment)
    end

    def load_scm
      @scms = children_of 'Scm'
    end

    def load_pre_install_tasks
      @pre_install = children_of 'PreInstall'
    end

    def run_pre_install_tasks deployment
      return if deployment.pre_install_tasks.nil? || deployment.pre_install_tasks.empty?

      deployment.pre_install_tasks.each do |task|
        task_klass = find_class_from_collection(@pre_install, 'pre_install', task['task'], deployment)
        task_klass.run(deployment, task['parameters'])
      end
    end

    def deployments
      yaml_file = File.join(Dir.pwd, 'deplo.yml')
      raise "Cannot find deployment YAML file #{yaml_file}" unless File.exists?(yaml_file)
      YAML.load_file(yaml_file).map {|d| Deployaml::Deployment.new(d) }.compact
    end
  end
end