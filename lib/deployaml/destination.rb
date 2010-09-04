require 'net/ssh'
require 'net/scp'
require 'open3'
require 'forwardable'

module Deployaml
  class Destination
    extend Forwardable

    def_delegators :@delegatee, :exec_and_verify, :install_from, :path

    def initialize params
      params['path'] || raise("A destination path must be specified")
      
      @delegatee = params.has_key?('host') ?
              Deployaml::RemoteDestination.new(params) :
              Deployaml::LocalDestination.new(params)
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