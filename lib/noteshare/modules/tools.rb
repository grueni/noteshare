module Noteshare
  module Tools

    def can_read(user)
      lambda{ |doc| Permission.new(user, :read, doc).grant }
    end

    def can_edit(user)
      lambda{ |doc| Permission.new(user, :read, doc).grant }
    end


    def self.symbolize_keys(hash)
      hash.inject({}){|new_hash, key_value|
        key, value = key_value
        value = symbolize_keys(value) if value.is_a?(Hash)
        new_hash[key.to_sym] = value if key
        new_hash
      }
    end

    class Object
      def symbolify

        if self.is_a?(Array)
          self.map { |mem| mem.symbolify }
        elsif self.is_a?(Hash)
          self.inject({}) do |res, (k, v)|
            res[k.to_sym] = v.symbolify
            res
          end
        else
          self
        end

      end
    end


  end
end