module Deployaml
  module PostInstall
    class PendingMigrations

      def run deployment, destination, params
        destination.exec("RAILS_ENV=production cd #{destination.live_path} && rake db:migrate")
      end

    end
  end
end