module Deployaml
  module PreInstall
    class WriteStringToFile

      def run deployment, params
        File.open(File.join(deployment.staging_path, params['file']), 'w') do |fh|
          fh.write(params['string'])
        end
      end

    end
  end
end