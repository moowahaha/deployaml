module Deployaml
  module PostInstall
    class Fizzle

      def run deployment, destination, params
        raise "fizzle"
      end

    end
  end
end