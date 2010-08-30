module Deployaml
  module Tasks
    class WriteStringToFile
      class << self

        def run path, params
          File.open(params['file'], 'w') do |fh|
            fh.write(params['string'])
          end
        end

      end
    end
  end
end