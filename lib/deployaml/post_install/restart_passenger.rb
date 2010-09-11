module Deployaml
  module PostInstall
    class RestartPassenger

      def run deployment, destination, params
        tmp_dir = File.join(destination.live_path, 'tmp')
        destination.exec('mkdir -p ' + tmp_dir)
        destination.exec('touch ' + File.join(tmp_dir, 'restart.txt'))
      end

    end
  end
end