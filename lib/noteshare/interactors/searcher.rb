require 'lotus/interactor'

class Searcher

  include Lotus::Interactor
  expose :documents, :nodes

  def initialize(params, user)
    @search_key = params['search']['search']
    puts "@search_key = #{@search_key}".green
    @user = user
  end

  def configure
    if @user
      @search_scope = @user.dict2['search_scope'] || 'all'
      @search_mode = @user.dict2['search_mode'] || 'document'
    else
      @search_scope = 'all'
      @earch_mode = 'document'
    end
    puts "search_mode = #{@search_mode}, search_scope = #{@search_scope}".green
  end

  def search_documents
    case @search_scope
      when 'global'
        puts "branch = GLOBAL"
        @documents = DocumentRepository.basic_search(nil, @search_key, 'document', 'all')
        @documents = @documents.select{ |item| item.acl_get(:world) =~ /r/ } || []
      when 'local'
        puts "branch = LOCAL"
        @documents = DocumentRepository.basic_search(@user, @search_key, @search_mode, 'personal') || []
      else
        puts "branch = EMPTY"
        @documents = DocumentRepository.basic_search(nil, @search_key, 'document', 'all')
        @documents = @documents.select{ |item| item.acl_get(:world) =~ /r/ } || []
    end
    puts "#{@documents.count} documents found"
  end

  def search_nodes
    @nodes = NSNodeRepository.search(@search_key).sort_by { |item| item.name }
    puts "#{@documents.count} nodes found"
  end

  def call
    configure
    search_documents
    search_nodes
  end

end

