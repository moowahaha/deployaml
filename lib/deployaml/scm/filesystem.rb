require File.dirname(__FILE__) + '/../scm_base'

module Deployaml
  module Scm
    class Filesystem < ScmBase
      def fetch_files
        raise "Cannot read repository #{deployment.repository_path} for '#{deployment.name}'" unless File.exists?(deployment.repository_path)

        FileUtils.cp_r(deployment.repository_path, File.dirname(deployment.staging_path), :remove_destination => true)
      end
    end
  end
end