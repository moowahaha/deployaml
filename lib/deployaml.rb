require 'fileutils'
require 'tmpdir'

Dir.glob(File.join(File.dirname(__FILE__), 'deployaml', '**', '*.rb')).each do |file|
  require file
end

module Deployaml
  class Runner
    VERSION = '0.0'

    class << self
      def go!
        deployments.each do |deployment|
          deployment_name = deployment['name'] || raise("Deployment has no name")
          repository_path = deployment['repository']['path']

          scm = Deployaml.const_get('Scm').const_get((deployment['repository']['scm'] || 'filesystem').capitalize).new
          scm.stage(deployment['repository']['path'], staging_directory)

          deployment['destinations'].each do |destination|
            FileUtils.mkdir_p(File.join(destination['path'], 'releases'))

            destination_path = File.join(destination['path'], 'releases', Time.now.strftime('%Y%M%d%H%M%S'))
            current_symlink = File.join(destination['path'], 'current')

            FileUtils.cp_r(
                    File.join(staging_directory, File.basename(deployment['repository']['path'])),
                    destination_path
            )

            File.unlink(current_symlink) if File.exists?(current_symlink)
            File.symlink(destination_path, current_symlink)
          end
        end
      end

      private

      def staging_directory
        dir = File.join(Dir.tmpdir, 'deployaml')
        FileUtils.mkdir(dir) unless File.directory?(dir)
        dir
      end

      def deployments
        yaml_file = File.join(Dir.pwd, 'deplo.yml')
        raise "Cannot find deployment YAML file #{yaml_file}" unless File.exists?(yaml_file)
        YAML.load_file(yaml_file)
      end
    end
  end
end