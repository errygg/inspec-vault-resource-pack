# InSpec HashiCorp Vault Resource Pack

## Prerequisites

* InSpec v4.7.3 or later
* Vault Server w/ authentication token

## Environment Configuration

In order to run the resources defined in this resource pack, the Vault URI and
token must be configured in the InSpec runtime environment.

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=<my-vault-token>
```

## Resource Usage

This is an InSpec "Resource Pack" and only defines resources that can be used
in other InSpec profiles.

### Create New Profile

```bash
inspec init profile my-vault-profile
```

The `inspec.yml` file for the new InSpec profile will need to include this
project as a dependency. For example:

```yaml
name: my-vault-profile
title: My Vault InSpec Profile
version: 0.1.0
inspec_version: '>=4.7.3'
depends:
  - name: inspec-vault-resource-pack
    url: https://github.com/errygg/inspec-vault-resource-pack/archive/0.1.0.tar.gz
```

## Resource Descriptions

TODO
