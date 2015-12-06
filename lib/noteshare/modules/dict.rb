module Noteshare
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