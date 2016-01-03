class PublicationsRepository
  include Lotus::Repository

  def self.for_node(node)
    name = node.class.name
    case name
      when 'NSNode'
        node_id = node.id
      when 'String'
        node_id = node.to_i
      else
        node_id = node # assume integer
    end
    query do
      where(node_id: node_id)
    end
  end

  def self.for_document(document)
    name = document.class.name
    case name
      when 'NSDocument'
        document_id = document.id
      when 'String'
        document_id = document.to_i
      else
        document_id = document # assume integer
    end
    query do
      where(document_id: document_id)
    end
  end

end
