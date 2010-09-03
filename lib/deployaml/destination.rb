require 'net/ssh'
require 'net/scp'
require 'open3'

module Deployaml
  class Destination
    attr_reader :path

    def initialize params
      @path = params['path'] || raise("A destination path must be specified")
      ssh_connect(params) if params.has_key?('host')
    end

    def install_from local_path
      FileUtils.mkdir_p(File.join(path, 'releases'))

      destination_path = File.join(path, 'releases', Time.now.strftime('%Y%M%d%H%M%S'))
      current_symlink = File.join(path, 'current')

      FileUtils.cp_r(
              local_path,
              destination_path
      )

      File.unlink(current_symlink) if File.exists?(current_symlink)
      File.symlink(destination_path, current_symlink)
    end

    def local_exec(command, extra_command, ok_message)
      had_error = true
      output = ''

      Open3.popen3(command + extra_command) do |stdin, stdout, stderr|
        stdout_output, stderr_output = stdout.read, stderr.read

        if !stdout_output.empty?
          if stdout_output.gsub!(/#{ok_message}\n/, '')
            had_error = false
          end

          output += stdout_output
          $stdout.print stdout_output
        end

        if !stderr_output.empty?
          output += stderr_output
          $stderr.print stderr_output
        end
      end

      return had_error, output
    end

    def remote_exec(command, extra_command, ok_message)
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

    def exec command
      ok_message = rand.to_s

      extra_command = " && echo #{ok_message}"

      had_error, output = self.send((@session ? 'remote_exec' : 'local_exec'), command, extra_command, ok_message)

      raise "Error executing '#{command}'" if had_error

      return output
    end

    private

    def ssh_connect params
      @session = Net::SSH.start(params['host'], params['username'])
    end
  end
end