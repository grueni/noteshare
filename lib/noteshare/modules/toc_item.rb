require 'json'
require_relative '../modules/tools'
include Noteshare::Tools

module Noteshare



  TOCItem = Struct.new(:id, :title, :identifier, :has_subdocs) do

    def encode
      self.to_h.to_json
    end

    def self.from_hash(hash)
      # hash = Noteshare::Tools.symbolize_keys(hash)
      keys = hash.keys
      return if keys.count == 0
      if keys[0].class.name == 'Symbol'
        self.new(hash[:id], hash[:title], hash[:identifier], hash[:subdocs])
      else
        self.new(hash['id'], hash['title'], hash['identifier'], hash['subdocs'])
      end
    end

    def self.decode(str)
      hash = JSON.parse str
      self.new(hash['id'], hash['title'], hash['identifier'], hash['subdocs'])
    end

    def self.decode2(str)
      hash = JSON.parse str
      self.from_hash(hash)
    end

  end

end