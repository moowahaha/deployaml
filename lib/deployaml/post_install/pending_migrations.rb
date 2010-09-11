module Deployaml
  module PostInstall
    class PendingMigrations

      def run deployment, destination, params
        destination.exec("cd #{destination.live_path} && rake db:migrate")
      end

    end
  end
end