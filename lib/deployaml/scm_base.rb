module Deployaml
  class ScmBase
    attr_reader :deployment

    def stage deployment
      @deployment = deployment
      fetch_files
      clean
    end

    def clean
      deploy_file = File.join(deployment.staging_path, 'deplo.yml')
      File.unlink(deploy_file) if File.exists?(deploy_file)
    end
  end
end