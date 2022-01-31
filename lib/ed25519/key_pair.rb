require 'securerandom'

module Ed25519
  class KeyPair
    attr_reader :seed, :signing_key, :verify_key

    # Import key pair by seed value or generate a new one
    def initialize seed = nil
      @seed = seed || SecureRandom.random_bytes(KEY_SIZE)
      keypair = Ed25519.provider.create_keypair(@seed)
      @signing_key = SigningKey.new(keypair[0, KEY_SIZE])
      @verify_key = VerifyKey.new(keypair[KEY_SIZE, KEY_SIZE])
    end # initialize
  
    def inspect
      "#<#{self.class}:#{@seed.unpack1('H*')}>"
    end # inspect
    
    def to_s
      [@signing_key, @verify_key].join
    end # to_s
  end # KeyPair
end # Ed25519