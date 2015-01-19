# MiddlemanEncrypt

middleman_encrypt encrypts web pages using AES 256 CBC encryption and decrypts them on the client side. This effectively enables password protection of static HTML pages.

This project should not be used with very sensitive data as there are [many problems](http://matasano.com/articles/javascript-cryptography/)  with performing client-side en/de-cryption. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman_encrypt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleman_encrypt

## Usage

Add `activate :encrypt` to your build step in your middleman app config file.

Options include:

* password: specify the password to use for en/de-cryption (recommended to store this in an ENV variable)
* iterations: default 1024, the number of iterations to run PBKDF2
* exts: defaults to [.htm, .html], an array of extensions to include for encryption - only works with text files (no binary)
* ignore: path patterns to ignore (i.e. not encrypt)

## Contributing

1. Fork it ( https://github.com/msnider/middleman_encrypt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
