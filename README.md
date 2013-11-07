# CryptBase64

*This is alpha code: review it before using to make sure you know what its doing, and agree with it.

OpenSSL returns keys, initialization vectors, and encrypted strings as hex strings, which is not very useful for passing around query strings and storing in databases.

CryptBase64 wraps OpenSSL AES, serializing to and from Base64.

It tries to figure out if what you pass in is base64, using a simple regex, and encodes it as necessary.


## Usage

In general you should hand it base64, and expect to get base64, except for decryption which returns plaintext as ascii.

NOTE: you should probably let the gem (and OpenSSL) handle creating keys and IVs for you, and store them after encryption.
The reason for this is complex, from the ruby OpenSSL docs:

"Symmetric encryption requires a key that is the same for the encrypting and for the decrypting party and after initial key establishment should be kept as private information. There are a lot of ways to create insecure keys, the most notable is to simply take a password as the key without processing the password further."

http://www.ruby-doc.org/stdlib-2.0.0/libdoc/openssl/rdoc/OpenSSL/Cipher.html

### Initialization

Initialization is a hash, it contains at a minimum data, which is either an encrypted base 64 string, or a plaintext string to be encrypted.

    CryptBase64::AES.new data: 'false flag'

Other options include mode and bits, which mirror AES/OpenSSL's allowed encryption options.  By default 128 bits and CBC mode are assumed.
Other modes may work but have not been tested.

These attributes can be set or retrieved via setters/getters.

### Encryption

    encrypted = cb.encrypt  # returns base64 encoded encrypted string
    key, iv = cb.key, cb.iv  # returns base64 encoded key and initialization vector used for encryption

### Decryption

    encrypted = "BD0U8YJTxQNT4Wp0sdnJLA=="
    cb.key = "lnHILUeMM11WMDDAjCIb/w=="
    cb.iv = "o3iPOzCxnBHMZmT9QYDUmA=="

    decrypted = cb.decrypt  # returns 'false flag'


## Installation

Add this line to your application's Gemfile:

    gem 'crypt_base64'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crypt_base64

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
