# Ed25519

A Ruby binding to the Ed25519 elliptic curve public-key signature system
described in [RFC 8032].

Two implementations are provided: a MRI C extension which uses the "ref10"
implementation from the SUPERCOP benchmark suite, and a pure Java version
based on [str4d/ed25519-java].

[RFC 8032]: https://tools.ietf.org/html/rfc8032
[str4d/ed25519-java]: https://github.com/str4d/ed25519-java

## What is Ed25519?

Ed25519 is a modern implementation of a [Schnorr signature] system using
elliptic curve groups.

Ed25519 provides a 128-bit security level, that is to say, all known attacks
take at least 2^128 operations, providing the same security level as AES-128,
NIST P-256, and RSA-3072.

Ed25519 has a number of unique properties that make it one of the best-in-class
digital signature algorithms:

* ***Small keys***: Ed25519 keys are only 256-bits (32 bytes), making them
  small enough to easily copy around. Ed25519 also allows the public key
  to be derived from the private key, meaning that it doesn't need to be
  included in a serialized private key in cases you want both.
* ***Small signatures***: Ed25519 signatures are only 512-bits (64 bytes),
  one of the smallest signature sizes available.
* ***Deterministic***: Unlike (EC)DSA, Ed25519 does not rely on an entropy
  source when signing messages. This can be a potential attack vector if
  the entropy source is not generating good random numbers. Ed25519 avoids
  this problem entirely and will always generate the same signature for the
  same data.
* ***Collision Resistant***: Hash-function collisions do not break this
  system. This adds a layer of defense against the possibility of weakness
  in the selected hash function.

You can read more on [Dan Bernstein's Ed25519 site](http://ed25519.cr.yp.to/).

[Schnorr signature]: https://en.wikipedia.org/wiki/Schnorr_signature

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

## Requirements

**ed25519.rb** is supported on and tested against the following platforms:

* MRI 2.4, 2.5, 2.6, 2.7, 3.0
* JRuby 9.2.19, 9.3.0

## Installation

Add this line to your application's Gemfile:

    gem 'ed25519', github: 'nixxlab/ed25519'

And then execute:

    $ bundle

# Usage

Generate a new key pair:

```ruby
require "ed25519"
key_pair = Ed25519::KeyPair.new
puts key_pair.signing_key.inspect
puts key_pair.verify_key.inspect
```

Import key pair by the seed (signing key - 32 bytes binary string):

```ruby
require "ed25519"
key_pair = Ed25519::KeyPair.new(seed)
puts key_pair.signing_key.inspect
puts key_pair.verify_key.inspect
```

Import signing key (32 bytes binary string) to making signature for a message:

```ruby
signing_key = Ed25519::SigningKey.new(key)
signing_key.sign(message)
```

Import verification key (32 bytes binary string) for checking of signed messages:

```ruby
verify_key = Ed25519::VerifyKey.new(key)
verify_key.verify(signature, message)
```

## Security Notes

The Ed25519 "ref10" implementation from SUPERCOP was lovingly crafted by expert
security boffins with great care taken to prevent timing attacks. The same
cannot be said for the C code used in the **ed25519.rb** C extension or in the
entirety of the provided Java implementation.

Care should be taken to avoid leaking to the attacker how long it takes to
generate keys or sign messages (at least until **ed25519.rb** itself can be audited
by experts who can fix any potential timing vulnerabilities)

**ed25519.rb** relies on a strong `SecureRandom` for key generation.
Weaknesses in the random number source can potentially result in insecure keys.
