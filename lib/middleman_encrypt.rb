require 'middleman-core'
require 'middleman_encrypt/version'

::Middleman::Extensions.register(:encrypt) do
  require 'middleman_encrypt/extension'
  ::Middleman::EncryptExtension
end
