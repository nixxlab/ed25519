module Ed25519
  class Seed
    def initialize seed = nil
      @seed = seed || SecureRandom.random_bytes(KEY_SIZE)
      raise TypeError, "expected String, got #{seed.class}" unless seed.is_a?(String)
      raise ArgumentError, "expected #{KEY_SIZE}-byte String, got #{seed.bytesize}" unless seed.bytesize == KEY_SIZE
    end # initialize

    def inspect
      "#<#{self.class}:#{@seed.unpack1('H*')}>"
    end # inspect

    def to_s
      @seed
    end # to_s
  end # Seed
end # Ed25519