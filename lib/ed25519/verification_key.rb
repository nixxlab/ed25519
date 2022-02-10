module Ed25519
  # Public key for verifying digital signatures
  class VerificationKey
    def initialize key
      raise TypeError, "expected String, got #{key.class}" unless key.is_a?(String)
      raise ArgumentError, "expected #{KEY_SIZE}-byte String, got #{key.bytesize}" unless key.bytesize == KEY_SIZE
      @key = key
    end # initialize

    # Show hex representation of serialized coordinate in string inspection
    def inspect
      "#<#{self.class}:#{@key.unpack1('H*')}>"
    end # inspect
    
    # Verify an Ed25519 signature against the message
    #
    # @param signature [String] 64-byte string containing an Ed25519 signature
    # @param message [String] string containing message to be verified
    #
    # @raise Ed25519::VerificationError signature verification failed
    #
    # @return [true] message verified successfully
    def verify signature, message
      if signature.length != SIGNATURE_SIZE
        raise ArgumentError, "expected #{SIGNATURE_SIZE} byte signature, got #{signature.length}" unless signature.length == SIGNATURE_SIZE
      end

      return true if Ed25519.provider.verify(@key, signature, message)

      raise VerificationError, "signature verification failed!"
    end # verify
    
    def size
      KEY_SIZE
    end # size

    # Return a compressed twisted Edwards coordinate representing the public key
    #
    # @return [String] bytestring serialization of this public key
    def to_s
      @key
    end # to_s
  end # VerificationKey
end # Ed25519
