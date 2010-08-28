require File.dirname(__FILE__) + '/scm_base'

module Deployaml
  module Scm
    class Filesystem < ScmBase
      def fetch_files
        raise "Cannot read repository #{repository_path}" unless File.exists?(repository_path)

        FileUtils.cp_r(repository_path, staging_root, :remove_destination => true)
      end
    end
  end
end