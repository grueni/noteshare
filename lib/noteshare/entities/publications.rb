# require '../repositories/publications_repository'


class Publications
  include Lotus::Entity

  attributes :id, :node_id, :document_id

  # for transiton only
  def self.add_documents_for_node(node)
    node.documents_as_hash.each do |title, doc_id|
      publication = Publication.find_for_pair(node.id, doc_id)
      if publication.nil?
        publication = Publications.new(node_id: node.id, document_id: doc_id)
        puts "#{title} => #{node.name}".red
        PublicationsRepository.create publication
      end
    end
  end

  def document
    DocumentRepository.find document_id
  end

  def document_title
    document.title
  end

  def node
    NSNodeRepository.find node_id
  end

  # Add publication record with given node_id and docuemnt_id
  # unless one of those id's is invalid, e.g., not present
  def self.add_record(node_id, document_id)
    return if (NSNodeRepository.find node_id) == nil
    return if (DocumentRepository.find document_id) == nil
    record = self.find_for_pair(node_id,document_id)
    if record == nil
      publication = Publications.new(node_id: node_id, document_id: document_id)
      PublicationsRepository.create publication
    end
  end

  def self.find_for_pair(node_id, document_id)
    PublicationsRepository.record_for_pair(node_id, document_id)
  end

  def self.remove(node_id, document_id)
    publication = PublicationsRepository.record_for_pair(node_id, document_id)
    PublicationsRepository.delete publication if publication
  end

  def self.records_for_node(node_id)
    PublicationsRepository.records_for_node(node_id)
  end

  def self.documents_for_node(node_id)
    p = PublicationsRepository.records_for_node(node_id)
    docs = []
    p.all.each do |record|
      doc = record.document
      if doc
        docs << doc
      else
        PublicationsRepository.delete record
      end
    end
    docs
  end

  def self.nodes_for_document(document_id)
    n = PublicationsRepository.records_for_document(document_id)
    nodes = []
    n.all.each do |record|
      nodes << record.node
    end
    nodes
  end




end
