require 'lotus/interactor'

class AdvancedSearcher

  include Lotus::Interactor
  expose :documents

  def initialize(params, user)
    @search_key = params['search']['search']
    puts "interactor: @search_key = #{@search_key}".green
    @user = user
  end

  def configure

  end

  def search_documents
    @documents = DocumentRepository.search_with_title(@search_key)
  end


  def call
    configure
    search_documents
  end

end

