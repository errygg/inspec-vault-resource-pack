require 'json'
require 'net/http'
require_relative 'helper'

class Policy < Inspec.resource(1)
  include VaultHelper

  name 'vault_policy'
  desc 'Reads the defined policy and provides data back to do compliance checks against.'

  def initialize(policy)
    @policy = policy
    @token = ENV['VAULT_TOKEN']
    @addr = ENV['VAULT_ADDR']
    @params = {}

    begin
      json_output = parse(run_api())
      @params = json_output
    rescue => exception
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
    str = "Vault policy: " + @policy
    str
  end

  private

  def run_api
    uri = URI("#{@addr}/v1/sys/policy/#{policy}")
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