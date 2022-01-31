require "ed25519/key_pair"
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

  # Perform a self-test to ensure the selected provider is working
  def self_test
    signing_key = Ed25519::SigningKey.new("A" * 32)
    raise SelfTestFailure, "failed to generate verify key correctly" unless signing_key.verify_key.to_bytes.unpack1("H*") == "db995fe25169d141cab9bbba92baa01f9f2e1ece7df4cb2ac05190f37fcc1f9d"

    message = "crypto libraries should self-test on boot"
    signature = signing_key.sign(message)
    raise SelfTestFailure, "failed to generate correct signature" unless signature.unpack1("H*") == "c62c12a3a6cbfa04800d4be81468ef8aecd152a6a26a81d91257baecef13ba209531fe905a843e833c8b71cee04400fa2af3a29fef1152ece470421848758d0a"

    verify_key = signing_key.verify_key
    raise SelfTestFailure, "failed to verify a valid signature" unless verify_key.verify(signature, message)

    bad_signature = "#{signature[0...63]}X"
    ex = nil
    begin
      verify_key.verify(bad_signature, message)
    rescue Ed25519::VerifyError => ex
    end

    raise SelfTestFailure, "failed to detect an invalid signature" unless ex.is_a?(Ed25519::VerifyError)
  end # self_test
end # Ed25519

# Automatically run self-test when library loads
Ed25519.self_test
