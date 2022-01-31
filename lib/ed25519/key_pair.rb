require 'securerandom'

module Ed25519
  class KeyPair
    attr_reader :signing_key, :verify_key
    alias_method :seed, :signing_key

    # Import key pair by seed value or generate a new one
    def initialize seed = nil
      @signing_key = SigningKey.new(seed)
      @verify_key = VerifyKey.new(
        Ed25519.provider.create_keypair(@signing_key.to_s)[KEY_SIZE, KEY_SIZE]
      )
    end # initialize
  
    def inspect
      "#<#{self.class}:#{to_s.unpack1('H*')}>"
    end # inspect
    
    def to_s
      [@signing_key, @verify_key].join
    end # to_s
  end # KeyPair
end # Ed25519