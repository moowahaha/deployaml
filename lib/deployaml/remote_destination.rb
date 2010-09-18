require 'net/ssh'
require 'net/scp'
require 'highline'

module Deployaml
  class RemoteDestination
    def initialize params
      @host = params['host'] || raise('A remote host must be specified')
      @username = params['username'] || ENV['USER']
    end

    def session
      @session_not_to_ever_be_called_directly ||= ssh_connect
    end

    def execute_and_verify(command, extra_command, ok_message)
      had_error = true
      output = ''

      session.exec!(command + extra_command) do |ch, stream, data|
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

    def copy from, to
      puts "Copying #{from} #{@username}@#{@host}:#{to}"
      compressed_file = compress(from, to)

      last_status_length = 0
      session.scp.upload!(compressed_file, to, :recursive => true) do |ch, name, sent, total|

        status_string = "#{sent}/#{total}"
        print "\b" * last_status_length
        last_status_length  = status_string.length
        print status_string
      end

      decompress(to)

      puts "\n"

    end

    private

    def compress from, to
      puts "Compressing for transfer..."
      root_directory, to_zip = File.dirname(from), File.basename(to)

      compressed_file = to_zip + '.tgz'
      `cd #{root_directory} && cp -rf #{from} #{to_zip} && tar -zcf #{compressed_file} #{to_zip}`

      File.join(root_directory, compressed_file)
    end

    def decompress destination
      puts "Inflating at destination..."
      destination_root = File.dirname(destination)
      compressed_file = File.basename(destination)
      session.exec!("cd #{destination_root} && tar -zxf #{compressed_file}")
    end

    def ssh_connect
      begin
        connect_without_password
      rescue Net::SSH::AuthenticationFailed
        connect_with_password
      end
    end

    def connect_without_password
      Net::SSH.start(@host, @username)
    end

    def connect_with_password
      flush_stdin
      Net::SSH.start(
              @host,
              @username,
              :password => HighLine.new.ask(
                      "#{@username}@#{@host}'s password: "
              ) { |a| a.echo = false }
      )
    end

    def flush_stdin
      begin
        require 'fcntl'
        STDIN.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
        STDIN.read
      rescue
        #
      end
    end

  end
end

# weird string monkey patch
class String
  def shellescape
    # An empty argument will be skipped, so return empty quotes.
    return "''" if self.empty?

    str = self.dup

    # Process as a single byte sequence because not all shell
    # implementations are multibyte aware.
    str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/n, "\\\\\\1")

    # A LF cannot be escaped with a backslash because a backslash + LF
    # combo is regarded as line continuation and simply ignored.
    str.gsub!(/\n/, "'\n'")

    return str
  end
end
