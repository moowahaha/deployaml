module Deployaml
  module Scm
    class Filesystem
      def stage repository_path, staging_destination
        raise "Cannot read repository #{repository_path}" unless File.exists?(repository_path)
        raise "Cannot find staging directory #{staging_destination}" unless File.directory?(staging_destination)

        FileUtils.cp_r(repository_path, staging_destination, :remove_destination => true)

        deploy_file = File.join(staging_destination, File.basename(repository_path), 'deplo.yml')
        File.unlink(deploy_file) if File.exists?(deploy_file)
      end
    end
  end
end