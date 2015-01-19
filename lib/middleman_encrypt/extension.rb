require 'middleman-core'
require 'middleman_encrypt/encryptor'
require 'middleman_encrypt/templator'

module Middleman
  class EncryptExtension < Middleman::Extension
    option :password, 'password', 'Password for decrypting the site.'
    option :iterations, 1024, 'Number of iterations to run PBKDF2 for'
    option :exts, %w(.html .htm), 'File extensions to Encrypt when building.'
    option :ignore, [], 'Patterns to avoid encrypting'

    def initialize(app, options_hash={})
      super
      require 'thread'
    end

    def after_build(builder)
      paths = ::Middleman::Util.all_files_under(app.build_dir)
      #paths.each do |path|
      #  encrypt_file(path.to_s) if should_encrypt?(path, builder)
      #end
      #return

      # Fill a queue with inputs
      in_queue = Queue.new
      paths.each do |path|
        in_queue << path if should_encrypt?(path)
      end
      num_paths = in_queue.size
      num_threads = [4, num_paths].min

      # Farm out encrypting tasks to threads and put the results in in_queue
      out_queue = Queue.new
      num_threads.times.each do
        Thread.new do
          while path = in_queue.pop
            builder.say_status :encrypt, "Encrypting File: #{path.to_s}", :blue
            out_queue << encrypt_file(path.to_s)
          end
        end
      end

      # Insert a nil for each thread to stop it
      num_threads.times do
        in_queue << nil
      end

      old_locale = I18n.locale
      I18n.locale = :en # use the english localizations for printing out file sizes to make sure the localizations exist

      total_savings = 0
      num_paths.times do
        output_filename, old_size, new_size = out_queue.pop
        next unless output_filename

        total_savings += (old_size - new_size)
        size_change_word = (old_size - new_size) > 0 ? 'smaller' : 'larger'
        builder.say_status :encrypt, "#{output_filename} (#{app.number_to_human_size((old_size - new_size).abs)} #{size_change_word})"
      end

      builder.say_status :encrypt, "Encrypting all files: complete", :blue
      I18n.locale = old_locale
    end

    def encrypt_file(path)
      # Read in the file contents
      contents = File.open(path, 'rb').read
      old_size = File.size(path)

      # Encrypt the file contents and build the encrypted HTML file
      aes = ::MiddlemanEncrypt::Encryptor.new(options.password, nil, options.iterations)
      encrypted64 = aes.encrypt(contents)
      html = ::MiddlemanEncrypt::Templator.new(
        options.iterations, ::MiddlemanEncrypt::Encryptor::KEY_SIZE, aes.salt64, aes.iv64, encrypted64).render

      # Write over the file with the new data
      File.open(path, 'wb') do |f|
        f.write html
      end

      new_size = File.size(path)
      [path, old_size, new_size]
    end

    # Whether a path should be encrypted
    # @param [Pathname] path A destination path
    # @return [Boolean]
    def should_encrypt?(path)
      options.exts.include?(path.extname) && options.ignore.none? { |ignore| Middleman::Util.path_match(ignore, path.to_s) }
    end
  end
end