require File.dirname(__FILE__) + '/scm_base'

module Deployaml
  module Scm
    class Git < ScmBase
      def fetch_files
        result = `git clone --depth=1 #{repository_path} #{staging_path} 2>&1`

        if result =~ /fatal:/
          raise "Cannot read repository #{repository_path}" if result =~ /not a git archive/ || result =~ /Could not switch to/
          raise "Error cloning #{repository_path}: #{result}"
        end

        `cd #{staging_path} && git submodule init && git submodule update`
      end

      def clean
        Dir.glob(File.join(staging_path, '**', '.git*')).each do |git_file|
          FileUtils.rm_r(git_file)
        end

        super
      end
    end
  end
end