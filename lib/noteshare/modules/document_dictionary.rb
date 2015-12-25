module Noteshare
  module NSDocumentDictionary

    #### PUBLISHING #####

    def set_principal_publisher_to_node(node)
      publisher_list = (dict['publisher'] || '').to_pair_list
      if publisher_list.count > 0
        publisher_list[0] = [node.name, node.id]
      else
        publisher_list = [[node.name, node.id]]
      end
      encode_publisher(publisher_list)
      DocumentRepository.update self
    end

    def set_principal_publisher_to_author(author)
      set_principal_publisher_to_node(author.node)
    end

    def get_principal_publisher
      publisher_list = dict['publisher'].to_pair_list
      publisher_list[0]
    end

    def encode_publisher(pair_list)
       str = ''
       pair_list.each do |pair|
         item = "#{pair[0]}, #{pair[1]}"
         str << item << "; "
       end
      dict['publisher'] = str[0..-2]
    end

  end
end