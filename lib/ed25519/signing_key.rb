require "securerandom"

module Ed25519
  # Private key for producing digital signatures
  class SigningKey
    # Import key or generate a new one
    def initialize key = nil
      if key
        raise TypeError, "expected String, got #{key.class}" unless key.is_a?(String)
        raise ArgumentError, "expected #{2 * KEY_SIZE}-byte String, got #{key.bytesize}" unless key.bytesize == 2 * KEY_SIZE
        @key = key
      else
        seed = SecureRandom.random_bytes(KEY_SIZE)
        @key = Ed25519.provider.create_keypair(seed)
      end # if
    end # initialize

    def inspect
      "#<#{self.class}:#{@key.unpack1('H*')}>"
    end # inspect

    # Sign the given message, returning an Ed25519 signature
    #
    # @param message [String] message to be signed
    #
    # @return [String] 64-byte Ed25519 signature
    def sign message
      Ed25519.provider.sign(@key, message)
    end # sign
    
    def size
      2 * KEY_SIZE
    end # size
    
    # Return a compressed twisted Edwards coordinate representing the private key
    #
    # @return [String] bytestring serialization of this private key
    def to_s
      @key
    end # to_s
  end # SigningKey
end # Ed25519
