module Deployaml
  class Destination
    attr_reader :path

    def initialize params
      @path = params['path'] || raise("A destination path must be specified")

      @delegatee = params.has_key?('host') ?
              Deployaml::RemoteDestination.new(params) :
              Deployaml::LocalDestination.new(params)
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

    def exec command
      ok_message = rand.to_s

      extra_command = " && echo #{ok_message}"

      had_error, output = @delegatee.execute_and_verify(command, extra_command, ok_message)

      raise "Error executing '#{command}'" if had_error

      return output
    end
  end
end