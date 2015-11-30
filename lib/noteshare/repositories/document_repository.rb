
# DocumentRespository provides services for
# persisence and search to NSDocument
class DocumentRepository
  include Lotus::Repository

  # Find all objects with a gvien title
  def self.find_by_title1(title)
    query do
      where(title: title)
    end
  end

  def self.find_by_title(key, limit: 8)
    array = fetch("SELECT id FROM documents WHERE title ILIKE '%#{key}%';")
    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| DocumentRepository.find id }.sort_by { |item| item.title }
  end

  # Return one ob4ect (or none0 whidh
  # have a given title
  # Fixme: this could be problmatic because
  # of the possibility of multiple objects with the same title
  def self.find_one_by_title(title)
    self.find_by_title(title).first
  end

  # Return all root documents
  def self.root_documents
    query do
      where(root_document_id: 0)
    end
  end

  def self.root_documents_for_user(author_id)
    query do
      where(root_document_id: 0, author_id: author_id)
    end
  end

  def self.root_document_by_title(key, limit: 8)
    array = fetch("SELECT id FROM documents WHERE parent_id = 0 AND title ILIKE '%#{key}%';")
    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| DocumentRepository.find id }.sort_by { |item| item.title }
  end


  # List all descendants of a given document
  def self.descendants(doc_id)
    query do
      where(parent_id: doc_id)
    end
  end

  # Destroy all descendants of a given
  # document and the document itself
  def self.destroy_tree(doc_id)
    descendants = self.descendants(doc_id)
    n = descendants.count
    descendants.each do |doc|
      DocumentRepository.delete doc
    end
    doc = DocumentRepository.find(doc_id)
    DocumentRepository.delete(doc)
    n
  end

end