require 'erb'

module MiddlemanEncrypt
  class Templator
    attr_accessor :iterations, :key_size, :salt64, :iv64, :encrypted64

    def initialize(iterations, key_size, salt64, iv64, encrypted64)
      @iterations = iterations
      @key_size = key_size
      @salt64 = salt64
      @iv64 = iv64
      @encrypted64 = encrypted64
    end

    def render()
      template = File.open(File.expand_path('../../../templates/decrypt.html.erb', __FILE__), 'r').read
      renderer = ERB.new(template)
      renderer.result(binding)
    end
  end
end