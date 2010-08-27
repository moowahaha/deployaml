require 'fileutils'

class Deployaml
  VERSION = '0.0'

  class << self
    def go!
      deployments.each do |deployment|
        repository_path = deployment['repository']['path']
        raise "Cannot find repository #{repository_path}" unless File.exists?(repository_path)

        deployment['destinations'].each do |destination|
          FileUtils.mkdir_p(File.join(destination['path'], 'releases'))

          destination_path = File.join(destination['path'], 'releases', Time.now.strftime('%Y%M%d%H%M%S'))
          current_symlink = File.join(destination['path'], 'current')

          FileUtils.cp_r(
                  repository_path,
                  destination_path
          )

          File.unlink(current_symlink) if File.exists?(current_symlink)
          File.symlink(destination_path, current_symlink)
        end
      end
    end

    private

    def deployments
      yaml_file = File.join(Dir.pwd, 'deplo.yml')
      raise "Cannot find deployment YAML file #{yaml_file}" unless File.exists?(yaml_file)
      YAML.load_file(yaml_file)
    end
  end
end