module Node::Controllers::Admin
  class Update
    include Node::Action

    expose :node, :active_item

    def update_dict(node, hash)
      hash.each do |key, value|
        puts "key = [#{key}] => [#{value}]".red
        if value == ''
          puts "delete key #{value}".cyan
          node.dict.delete(key)
        else
          puts "set: #{key} = #{value}".cyan
          node.dict[key] = value
        end
      end
    end

    def call(params)
      @active_item = 'admin'

      data = params['node']
      node_id  = data['node_id']
      dictionary = data['dictionary']

      node = NSNodeRepository.find node_id
      puts "node_id  =  #{node_id}".cyan
      puts "dictionary  =  #{dictionary}".cyan

      # get the other hash elements
      dictionary = dictionary.gsub(/\n\n*/m, "\n")
      hash = dictionary.hash_value(":\n")

      node.update_publication_records_from_string(hash['docs']) if hash['docs']
      hash.delete('docs')
      update_dict(node, hash)
      NSNodeRepository.update node
      redirect_to "/node/#{node_id}"
    end
  end
end
