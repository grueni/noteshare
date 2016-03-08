# require '../repositories/publications_repository'


class Publications
  include Lotus::Entity

  attributes :id, :node_id, :document_id, :type
  # type can be 'author', 'principal', or ''

  # for transiton only
  def self.add_documents_for_node(node)
    node.documents_as_hash.each do |title, doc_id|
      publication = Publication.find_for_pair(node.id, doc_id)
      if publication.nil?   # create new publication record only if it does not exist
        publication = Publications.new(node_id: node.id, document_id: doc_id, type: 'author')
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

  # Add publication record with given node_id and document_id
  # unless one of those id's is invalid, e.g., not present
  def self.add_record(node_id, document_id, type)
    return if (NSNodeRepository.find node_id) == nil
    return if (DocumentRepository.find document_id) == nil
    record = self.find_for_pair(node_id,document_id)
    if record == nil
      publication = Publications.new(node_id: node_id, document_id: document_id, type: type)
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
    records = PublicationsRepository.records_for_document(document_id)
    nodes = []
    records.all.each do |record|
      #fixme: why should the if clause be necessary (bad data?)
      nodes << record.node if record.node
    end
    nodes
  end

  def set_default_type
    node = NSNodeRepository.find self.node_id
    if node == nil
      PublicationsRepository.delete self
      return
    end
    if node.type == 'public'
      self.type = 'principal'
    else
      self.type = 'author'
    end
    PublicationsRepository.update self
  end

  def self.set_type_for_all
    count = 0
    DocumentRepository.root_documents.each do |doc|
      puts "doc: #{doc.id}"
      records = PublicationsRepository.records_for_document doc.id
      records = records.select{ |r| r != nil }
      puts "  #{records.count}"
      case records.count
        when 1
          record = records.first
          record.type = 'author'
          PublicationsRepository.update record
        when 2
           records.each do |record|
             record.set_default_type
           end
        else
          count += 1
          puts "  document #{doc.id} #{doc.title} has #{records.count} publishers"
      end
    end
    count
  end


  def command_url(screen_name, command)
    _url = "editor/manage_publications/#{self.id}?#{command}"
    basic_link(screen_name, _url)
  end

  def publicationsManager
    doc = DocumentRepository.find self.document_id
    PublicationsManager.new(doc) if doc
  end

  def set_type(new_type)
    self.type = new_type
    PublicationsRepository.update self
  end

  def set_pp

    records = PublicationsRepository.records_for_document self.document_id
    records.each do |record|
      if record.type == 'principal'
        record.type = 'standard'
        PublicationsRepository.update record
      end
    end

    self.type = 'principal'
    PublicationsRepository.update self

  end


  def self.execute_command(cmd, record_id)

    record  = PublicationsRepository.find record_id
    if record == nil
      puts "#{record_id} is a NIL record".magenta
    end
    return 'error: string too long' if cmd.length > 100

    case cmd
      when 'delete'
        PublicationsRepository.delete record
      when 'principal'
        record.set_pp
      when 'author'
        record.set_type('author')
      when 'standard'
        record.set_type('standard')
      when 'test'
        puts "test: #{arg}".red
      else
        return 'error:unknown command'
    end
  end

  def doc_title
    doc = Document_Repository.find document_id
    doc.title
  end


end

class PublicationsManager

  def initialize(document)
    @document = document
  end

  def principal_publisher
    query = PublicationsRepository.principal_publisher_for_document(@document.id)
    record = query.first
    NSNodeRepository.find record.node_id if record
  end

  def author_node
    user = UserRepository.find @document.author_credentials2['id']
    user.node if user
  end


  def link_prefix(session, node)
    user = current_user(session)
    if user
      user.screen_name
    else
      node.name
    end
  end


  def principal_publisher_link(session)

    node1 = principal_publisher
    if node1
      puts "IN principal_publisher_link, node1 = #{node1.name}".magenta
    else
      puts 'principal_publisher is NIL'
    end

    if node1
      link_text = "Published in #{node1.name}#{ENV['DOMAIN']}"
      prefix = link_prefix(session, node1)
      link = basic_link(prefix, "node/#{node1.id}")
      return "<a href=\"#{link}\">#{link_text}</a>"
    else
      node2 = author_node
      return '' if node2 == nil
      link_text = "Published in #{node2.name}#{ENV['DOMAIN']}"
      link = basic_link(node2.name, "node/#{node2.id}")
      return "<a href=\"#{link}\">#{link_text}</a>"
    end
  end

  def publishers
    records = PublicationsRepository.records_for_document @document.id
    _publishers = {}
    records.each do |record|
      node = NSNodeRepository.find record.node_id
      if node
        _publishers[node.name] = {node_id: node.id, record_id: record.id, type: record.type}
      end
    end
    _publishers
  end

  def set_principal_publisher_to_node(node_name)

    records = PublicationsRepository.records_for_document @document.id
    records.each do |record|
      if record.type == 'principal'
        record.type = ''
        PublicationsRepository.update record
      end
    end

    node = NSNodeRepository.find_one_by_name node_name
    record = Publications.find_for_pair(node.id, @document.id)
    if record
      record.type = 'principal'
      PublicationsRepository.update record
    end

  end

  def delete_publication_for_node(node_name)
    node = NSNodeRepository.find_one_by_name node_name
    if node == nil
      puts "NODE IS NIL".magenta
    end
    if node
      record = Publications.find_for_pair(node.id, @document.id)
     PublicationsRepository.delete record if record
    end
  end


end
