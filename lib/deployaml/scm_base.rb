module Deployaml
  class ScmBase
    attr_reader :deployment, :version

    def stage deployment, version = nil
      @deployment = deployment
      @version = version
      fetch_files
      clean
    end

    def clean
      deploy_file = File.join(deployment.staging_path, 'deplo.yml')
      File.unlink(deploy_file) if File.exists?(deploy_file)
    end
  end
end