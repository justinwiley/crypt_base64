module CryptBase64
  class AES
    attr_accessor :data, :key, :iv, :bits, :mode, :cipher

    def initialize opts
      self.bits = opts[:bits] || 128
      self.mode = opts[:mode] || :CBC
      self.data = opts[:data]

      self.cipher = OpenSSL::Cipher::AES.new(bits, mode)
      self.key = opts[:key] || genkey
      self.iv = opts[:iv] || geniv

      check64 key, iv
    end

    def is_64?(val); val.is_a?(String) && val.match(/^[A-Za-z0-9+\/]+={0,3}$/); end
    def decode_if_64(val); is_64?(val) ? Base64::decode64(val) : val; end
    def encode_unless_64(val); is_64?(val) ? val : Base64::strict_encode64(val); end

    # raise if values dont look like base64 encoded
    def check64 *vals
      vals.flatten.map do |val|
        raise ArgumentError.new("Must pass in base64 encoded string, got #{val.inspect}") unless is_64?(val)
      end
    end

    # convert data from base64 as necessary on assignment
    def data=(val)
      @data = decode_if_64 val
    end

    # generate secure key for encryption
    # note if this method is not used, secure key generation must be used
    # key should NOT be plaintext string of type "my s3cr3t", see ruby open ssl docs
    def genkey
      Base64::strict_encode64 cipher.random_key
    end

    # similar to genkey, generate secure iv
    def geniv
      Base64::strict_encode64 cipher.random_iv
    end

    # encrypt, return base64 encoded ciphertext
    def encrypt
      cipher.encrypt
      cipher.iv = decode_if_64(iv)
      cipher.key = decode_if_64(key)
      
      encrypted = cipher.update(data) + cipher.final
      Base64::strict_encode64 encrypted
    end

    # decrypt, return plaintext
    def decrypt    
      cipher.decrypt
      cipher.key = decode_if_64(key)
      cipher.iv = decode_if_64(iv)

      unencoded_data = decode_if_64(data)
      decrypted = cipher.update(unencoded_data) + cipher.final
    end  
  end
end