require 'lotus/interactor'

class AdvancedSearcher

  include Lotus::Interactor
  expose :documents

  def initialize(params, user)
    @commands = ['ti', 'ta']
    @search_key = params['search']['search']
    parts = @search_key.split(' ')
    if parts.count > 1 and @commands.include? parts[0]
      @command = parts[0]
      @search_key = @search_key.sub(@command, '').strip
    end
    @user = user
  end

  def configure

  end

  def advanced_search
    case @command
      when 'ti'
        @documents = DocumentRepository.search_with_title(@search_key)
      when 'ta'
        @documents = DocumentRepository.search_with_tags(@search_key)
      else
        @documents = DocumentRepository.search_with_title(@search_key)
    end
  end

  def search_documents
    if @command == nil
      @documents = DocumentRepository.search_with_title(@search_key)
    else
      advanced_search
    end
  end


  def call
    configure
    search_documents
  end

end

