require 'spec_helper'

describe CryptBase64::AES do
  let(:plaintext) { 'False flag'}
  let(:cb){ CryptBase64::AES.new({data: plaintext}) }
  let(:cipher) { OpenSSL::Cipher::AES.new(128, :CBC) }

  def assert_base64 *vals
    cb.check64 vals
  end

  context 'initialization' do
    it 'should initialize and set defaults if none given' do
      cb.bits.should == 128
      cb.mode.should == :CBC
      assert_base64 cb.key, cb.iv
    end

    it 'should accept ascii or base64 plaintext, convert to ascii as necessary' do
      b64 = Base64::strict_encode64 plaintext
      cb.data = plaintext
      cb.data.should == plaintext
      cb.data = b64
      cb.data.should == plaintext
    end

    it 'should complain if not given required args or given in non base64' do
      hex = ["not base64"].pack('H*')
      expect {CryptBase64::AES.new}.to raise_error(ArgumentError)
      expect {CryptBase64::AES.new(key: hex)}.to raise_error(ArgumentError)
      expect {CryptBase64::AES.new(iv: hex)}.to raise_error(ArgumentError)
    end
  end

  context 'encryption/decryption' do
    it '#encrypt should return aes encrypted, base64 string that can be unencrypted use openssl aes with same key and iv' do
      enc64 = cb.encrypt
      assert_base64(enc64)

      enc = Base64::decode64 enc64

      cipher.decrypt
      cipher.key = Base64::decode64 cb.key
      cipher.iv = Base64::decode64 cb.iv
      decrypted = cipher.update(enc) + cipher.final
      decrypted.should == plaintext
    end

    it '#decrypt should decrypt openssl generated aes with same key and iv' do
      cipher.encrypt
      cipher.key = Base64::decode64 cb.key
      cipher.iv = Base64::decode64 cb.iv
      encrypted = cipher.update(plaintext) + cipher.final
      
      cb.data = encrypted
      cb.decrypt.should == plaintext
    end

    it '#decrypt should seamlessly decrypt #encrypt output' do
      enc = cb.encrypt
      assert_base64(enc)
      cb.data = enc
      cb.decrypt.should == plaintext
    end

  end
end