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
      redirect_if_not_signed_in('image, Admin,  Update')
      @active_item = 'admin'

      data = params['node']
      node_id  = data['node_id']
      dictionary = data['dictionary']

      node = NSNodeRepository.find node_id
      puts "node_id  =  #{node_id}".cyan
      puts "dictionary  =  #{dictionary}".cyan

=begin
      # get the block elements of the string
      # representing elements of the hash
      element_pairs = Tools.get_elements dictionary
      elements = []
      element_pairs.each do |item|
        elements << "[#{item[0]}]\n--\n#{item[1]}\n--\n"
      end
      puts "elements: \n#{elements}".blue
      puts "element_pairs: #{element_pairs}".green



      # delete those elements from the string
      elements.each do |item|
        item  = item.gsub("\r\n", "\n")
        dictionary = dictionary.sub(item, '')
       end

      dictionary = dictionary.gsub(/\[(.*?)\][\r\n]{1,2}--[\r\n]{1,2}(.*?)[\r\n]{1,2}--[\r\n]{1,2}/, '')


      puts "edited dictionary: #{dictionary}".red
=end

      # get the other hash elements
      dictionary = dictionary.gsub(/\n\n*/m, "\n")
      hash = dictionary.hash_value(":\n")

=begin
      # add the block elements back to the hash
      element_pairs.each do |item|
        hash[item[0]] = item[1]
      end
=end
      node.update_publication_records_from_string(hash['docs']) if hash['docs']
      hash.delete('docs')
      update_dict(node, hash)
      NSNodeRepository.update node
      redirect_to '/node/admin'
    end
  end
end
