require File.dirname(__FILE__) + '/../scm_base'

module Deployaml
  module Scm
    class Git < ScmBase
      def fetch_files
        cloned?(`git clone --depth=1 #{deployment.repository_path} #{deployment.staging_path} 2>&1`)

        `cd #{deployment.staging_path} && git submodule init && git submodule update`
      end

      def cloned? result
        if result =~ /fatal:/
          raise "Cannot read repository #{deployment.repository_path} for '#{deployment.name}'" if result =~ /not a git archive/ || result =~ /not appear to be a git repository/ || result =~ /Could not switch to/
          raise "Error cloning #{deployment.repository_path}: #{result}"
        end
      end

      def clean
        # remove all the gittish files
        Dir.glob(File.join(deployment.staging_path, '**', '.git*')).each do |git_file|
          FileUtils.rm_r(git_file)
        end

        super
      end
    end
  end
end