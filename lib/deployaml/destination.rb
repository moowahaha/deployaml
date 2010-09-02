require 'net/ssh'
require 'net/scp'

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

    def exec command
      @session ? @session.exec!(command) : `#{command} 2>&1`
    end

    private

    def ssh_connect params
      @session = Net::SSH.start(params['host'], params['username'])
    end
  end
end