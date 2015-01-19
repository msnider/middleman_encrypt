require 'openssl'
require 'base64'

class MiddlemanEncrypt::Encryptor
  CIPHER = 'aes-256-cbc'
  KEY_SIZE = 256 # bits (divide by 8 for bytes)
  attr_reader :salt, :salt64, :key, :key64, :iterations, :iv, :iv64

  def initialize(password, salt = nil, iterations = 1000)
    @password = password
    @iterations = iterations
    generate_salt!(salt)
    generate_key!
    generate_iv!
  end

  def encrypt(data)
    cipher = OpenSSL::Cipher::Cipher.new(CIPHER)
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv
    encrypted = cipher.update(data) + cipher.final
    encrypted64 = Base64.encode64(encrypted).gsub(/\n/, '')
    encrypted64
  end
  def decrypt(encrypted64)
    encrypted = Base64.decode64(encrypted64)
    cipher = OpenSSL::Cipher::Cipher.new(CIPHER)
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    decrypted = cipher.update(encrypted) + cipher.final
    decrypted
  end

  def generate_salt!(salt = nil)
    @salt = salt || OpenSSL::Random.random_bytes(16)
    @salt64 = Base64.encode64(@salt).gsub(/\n/, '')
  end
  def generate_key!
    @key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@password, @salt64, @iterations, KEY_SIZE / 8)
    @key64 = Base64.encode64(@key).gsub(/\n/, '')
  end
  def generate_iv!
    @iv = OpenSSL::Cipher::Cipher.new(CIPHER).random_iv
    @iv64 = Base64.encode64(@iv).gsub(/\n/, '')
  end

end