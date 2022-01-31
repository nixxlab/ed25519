require "ed25519/key_pair"
require "ed25519/seed"
require "ed25519/signing_key"
require "ed25519/verify_key"

# The Ed25519 digital signatre algorithm
module Ed25519
  module_function

  # Raised when a signature fails to verify
  VerifyError = Class.new(StandardError)

  # Raised when the built-in self-test fails
  SelfTestFailure = Class.new(StandardError)

  class << self
    # Obtain the backend provider module used to perform signatures
    attr_accessor :provider
  end

  # Select the Ed25519::Provider to use based on the current environment
  if defined? JRUBY_VERSION
    require 'jruby'
    require 'ed25519_jruby'
    self.provider = org.cryptorb.Ed25519Provider.createEd25519Module(JRuby.runtime)
  else
    require 'ed25519_ref10'
    self.provider = Ed25519::Provider::Ref10
  end

  KEY_SIZE = 32
  SIGNATURE_SIZE = 64
end # Ed25519
