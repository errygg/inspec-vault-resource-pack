require 'json'
require 'net/http'
require_relative 'helper'

class AuthMethod < Inspec.resource(1)
  include VaultHelper

  name 'vault_auth_method'
  desc 'Reads the path parameter and provides data on the auth method back to do compliance checks against.'

  def initialize(path)
    @path  = path
    @token = ENV['VAULT_TOKEN']
    @addr  = ENV['VAULT_ADDR']
    @params = {}

    begin
      json_output = parse(run_api())
      @params = json_output
      @params["type"] = json_output[path]["type"]
      @params["default_lease_ttl"] = json_output[path]["config"]["default_lease_ttl"]
      @params["max_lease_ttl"] = json_output[path]["config"]["max_lease_ttl"]
      @params["token_type"] = json_output[path]["config"]["token_type"]

    rescue StandardError => e
      raise Inspec::Exceptions::ResourceSkipped, "#{e.message}"
    end
  end

  def method_missing(name)
    @params[name.to_s]
  end

  def stdout
    @vault_command.stdout
  end

  def stderr
    @vault_command.stderr
  end

  def to_s
    str = "Vault auth method path: " + @path
    str
  end

  private

  def run_api
    uri = URI("#{@addr}/v1/sys/auth")
    req = Net::HTTP::Get.new(uri)
    req['X-Vault-Token'] = @token
    # TODO: add SSL support
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }

    return skip_resource "Unable to authenticate, Vault is sealed" if is_vault_sealed?(res.body)

    res.body

  end
end
