module Deployaml
  class LocalDestination
    attr_reader :path

    def initialize params
      @path = params['path']
    end

    def execute_and_verify(command, extra_command, ok_message)
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

  end
end