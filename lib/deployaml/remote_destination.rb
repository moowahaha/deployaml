module Deployaml
  class RemoteDestination
    attr_reader :path

    def initialize params
      @path = params['path']
      params['host'] || raise('A remote host must be specified')
      ssh_connect(params)
    end

    def execute_and_verify(command, extra_command, ok_message)
      had_error = true
      output = ''

      @session.exec!(command + extra_command) do |ch, stream, data|
        if stream == :stderr
          $stderr.print data
          output += data
        else
          if data.strip == ok_message
            had_error = false
          else
            $stdout.print data
            output += data
          end
        end
      end

      return had_error, output
    end

    private

    def ssh_connect params
      @session = Net::SSH.start(params['host'], params['username'])
    end

  end
end