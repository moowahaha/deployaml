class Deployaml
  VERSION = '0.0'

  class << self
    def go!
      yaml_file = File.join(Dir.pwd, 'deplo.yml')
      raise "Cannot find deployment YAML file #{yaml_file}" unless File.exists?(yaml_file)
      yaml = YAML.load_file(yaml_file)

      repository_path = yaml['repository']['path']
      raise "Cannot find repository #{repository_path}" unless File.exists?(repository_path)

      yaml['destinations'].each do |destination|
        FileUtils.mkdir_p(File.join(destination['path'], 'releases'))

        destination_path = File.join(destination['path'], 'releases', Time.now.strftime('%Y%M%d%H%M%S'))
        current_symlink = File.join(destination['path'], 'current')

        FileUtils.cp_r(
                repository_path,
                destination_path
        )

        File.unlink(current_symlink)

        File.symlink(destination_path, current_symlink)
      end
    end
  end
end