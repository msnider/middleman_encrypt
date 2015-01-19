require 'minitest/autorun'
require 'middleman_encrypt/templator'

class TestTemplator < Minitest::Test

  def test_no_errors
    t = MiddlemanEncrypt::Templator.new(1024, 256, 'salt', 'iv', 'encrypted data') #terations, key_size, salt64, iv64, encrypted64)
puts t.render
    assert !t.nil?
  end

end