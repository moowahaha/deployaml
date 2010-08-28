module Deployaml
  module Scm
    class Git
      def stage repository_path, staging_destination
        raise "Cannot find staging directory #{staging_destination}" unless File.directory?(staging_destination)

        clone_dir = File.join(staging_destination, File.basename(repository_path))

        FileUtils.rm_r(clone_dir) if File.exists?(clone_dir)

        result = `git clone --depth=1 #{repository_path} #{clone_dir} 2>&1`

        if result =~ /fatal:/
          raise "Cannot read repository #{repository_path}" if result =~ /not a git archive/ || result =~ /Could not switch to/
          raise "Error cloning #{repository_path}: #{result}"
        end

        `cd #{clone_dir} && git submodule init && git submodule update`

        # de-gittify
        Dir.glob(File.join(clone_dir, '**', '.git*')).each do |git_file|
          FileUtils.rm_r(git_file)
        end

        File.unlink(File.join(clone_dir, 'deplo.yml')) if File.exists?(File.join(clone_dir, 'deplo.yml'))
      end
    end
  end
end