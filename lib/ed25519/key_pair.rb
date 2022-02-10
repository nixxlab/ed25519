require 'securerandom'

module Ed25519
  class KeyPair
    attr_reader :signing_key, :virification_key
    alias_method :seed, :signing_key

    # Import key pair by seed value or generate a new one
    def initialize seed = nil
      full_key = Ed25519.provider.create_keypair(seed)
      @signing_key = SigningKey.new(full_key)
      @virification_key = VerificationKey.new(full_key[KEY_SIZE, KEY_SIZE])
    end # initialize
  
    def inspect
      "#<#{self.class}:#{to_s.unpack1('H*')}>"
    end # inspect

    def size
      2 * KEY_SIZE
    end # size
    
    def to_s
      [@signing_key, @virification_key].join
    end # to_s
  end # KeyPair
end # Ed25519