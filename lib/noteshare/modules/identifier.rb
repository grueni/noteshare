require 'securerandom'

module Noteshare
  class Identifier

    include SecureRandom

    def initialize(text=nil)
      @text = text
    end

    def normalize
      @text = @text.gsub(' ', '_').downcase
      @text = @text.gsub(/[^a-zA-Z_]/, '')
      @text = @text.gsub(/_*_/, '_')
    end

    def string
      normalize if @text != nil
      if @text
        @text = @text + '::' + SecureRandom.hex(10)
      else
        @text = SecureRandom.hex(10)
      end

    end


    def reset(new_head)
      tail = @text.split('::')[1]
      @text = new_head
      normalize
      @text = @text + '::' + tail
    end


    # Set identifiers for documents which do not have them.`                                                                                                                                                                  `
    def self.set
      count = 0
      DocumentRepository.all.each do |document|
        if document.identifier == nil
          document.identifier = Identifier.new().string
          DocumentRepository.update document
          count += 1
        end
      end
      count
    end

  end
end