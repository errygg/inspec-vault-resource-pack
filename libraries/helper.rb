require 'json'

module VaultHelper
  def parse(output)
    return [] if output.nil?

    JSON.parse(output)

  rescue JSON::ParserError => e
    skip_resource "Unable to parse JSON response from `vault` command: #{e.message}"
    []
  end

  def is_vault_sealed?(output)
    output.include?('Vault is sealed')
  end
end