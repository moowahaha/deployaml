module Deployaml
  module Scm
    class ScmBase
      attr_reader :repository_path, :staging_path, :staging_root

      def stage repository_path, staging_destination
        @repository_path, @staging_root = repository_path, staging_destination
        @staging_path = File.join(staging_destination, File.basename(@repository_path))

        check_staging_path

        FileUtils.rm_r(@staging_path) if File.exists?(@staging_path)

        fetch_files

        clean
      end

      def check_staging_path
        raise "Cannot find staging directory #{staging_root}" unless File.directory?(staging_root)
      end

      def clean
        deploy_file = File.join(staging_path, 'deplo.yml')
        File.unlink(deploy_file) if File.exists?(deploy_file)
      end
    end
  end
end