require 'lotus/interactor'

class UpdateNode

  include Lotus::Interactor
  expose :new_document, :error

  def initialize(node_id, dictionary)
    @node =  NSNodeRepository.find node_id
    @dictionary = dictionary
  end

  def update_dict
    @hash.delete('docs')
    @hash.each do |key, value|
      if value == ''
        @node.dict.delete(key)
      else
        @node.dict[key] = value
      end
    end
  end

  def call
    @dictionary = @dictionary.gsub(/\n\n*/m, "\n")
    @hash = @dictionary.hash_value(":\n")
    @node.update_publication_records_from_string(hash['docs']) if hash['docs']
    update_dict
    NSNodeRepository.update @node
  end

end
