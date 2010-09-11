module Deployaml
  class Destination
    attr_reader :path, :live_path

    def initialize params
      @path = params['path'] || raise("A destination path must be specified")
      @live_path = File.join(path, 'current')

      @delegatee = params.has_key?('host') ?
              Deployaml::RemoteDestination.new(params) :
              Deployaml::LocalDestination.new(params)
    end

    def install_from local_path
      exec("mkdir -p #{File.join(path, 'releases')}")

      destination_path = File.join(path, 'releases', Time.now.strftime('%Y%m%d%H%M%S'))

      # TODO: replace this with a @delegatee.copy
      @delegatee.copy(local_path, destination_path)
      #FileUtils.cp_r(local_path, destination_path)

      exec("rm -f #{live_path}")
      exec("ln -s #{destination_path} #{live_path}")
    end

    def exec command
      ok_message = rand.to_s

      extra_command = " && echo #{ok_message}"

      puts "$ #{command}"
      had_error, output = @delegatee.execute_and_verify(command, extra_command, ok_message)
      puts "\n"

      raise "Error executing '#{command}'" if had_error

      return output
    end
  end
end