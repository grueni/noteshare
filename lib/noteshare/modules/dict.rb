module Noteshare


  # Module Dict ads methods for decoding, encoding, manipulating,
  # and storing 'dictionary data' stored in an objects 'meta'
  # field.  It is assumed that this field is a string representation
  # of something in JSON format.  Them methods below only affect
  # the value of `meta['dict']`.
  #
  # The methods are such that changes to the receiver are
  # saved in the corresponding object repository.  Consider, for
  # example, the method #dict_update(entry), to see how this is done.
  module Dict

    def dict_set(new_dict)
      metadata = JSON.parse self.meta
      metadata['dict'] = new_dict
      self.meta = JSON.generate metadata
      puts self.class.name.green

      Object.const_get("#{self.class.name}Repository").send(:update, self )
      # UserRepository.update self
    end

    def dict_update(entry)
      metadata = JSON.parse self.meta
      dict = metadata['dict'] || { }
      dict[entry.keys[0]] = entry.values[0]
      metadata['dict'] = dict
      self.meta = JSON.generate metadata
      Object.const_get("#{self.class.name}Repository").send(:update, self )
      # UserRepository.update self
    end

    def dict_update_from_hash(hash)
      metadata = JSON.parse self.meta
      dict = metadata['dict'] || { }
      hash.each do |key, value|
        dict[key] = value
      end
      metadata['dict'] = dict
      self.meta = JSON.generate metadata
      Object.const_get("#{self.class.name}Repository").send(:update, self )
      # UserRepository.update self
    end

    def dict_remove(key)
      metadata = JSON.parse self.meta
      dict = metadata['dict'] || { }
      dict.delete(key)
      metadata['dict'] = dict
      self.meta = JSON.generate metadata
      Object.const_get("#{self.class.name}Repository").send(:update, self )
      # UserRepository.update self
    end

    def dict_lookup(key)
      metadata = JSON.parse self.meta
      dict = metadata['dict'] || { }
      dict[key]
    end

    def editable_keys
      %w(render_with)
    end

    def dict_to_s(filter=[])
      metadata = JSON.parse self.meta
      dict = metadata['dict'] || { }
      output = ''
      dict.each do |key, value|
        if filter.include? key
          output << "#{key} = #{value}" << "\n"
          filter.delete(key)
        end
      end
      filter.each do |key|
        output << "#{key} = " << "\n"
      end
      output
    end

    def dict_display
      puts dict_to_s
    end

  end
end