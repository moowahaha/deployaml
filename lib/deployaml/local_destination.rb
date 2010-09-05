require 'open3'

module Deployaml
  class LocalDestination
    def initialize params
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

    def copy from, to
      FileUtils.cp_r(from, to)
    end

  end
end