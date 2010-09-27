module Deployaml
  module PostInstall
    class Symlink

      def run deployment, destination, params
        params.each do |symlink|
          raise('source not specified for symlink') unless symlink['source']
          raise('target not specified for symlink') unless symlink['target']

          destination.exec("ln -sfF #{symlink['source']} #{File.join(destination.live_path, symlink['target'])} ")
        end
      end

    end
  end
end