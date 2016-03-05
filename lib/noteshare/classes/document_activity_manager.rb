
# ActivityManager records
# the documents a user
# views and can present
# a list of this activity
class DocumentActivityManager



  def initialize(document, user)
    @document = document
    @user = user
  end

  def record
    array = @user.docs_visited
    dv = DocsVisited.new(array, ENV['DOCS_VISITED_CAPACITY'])
    dv.push_doc(@document)
    @user.docs_visited = dv.stack
    UserRepository.update @user
  end


  # @document can be nil for this method:
  def list(view_mode)
    array = @user.docs_visited || []
    array = array.reverse
    dv = DocsVisited.new(array, ENV['DOCS_VISITED_CAPACITY'])
    output = "<ul>\n"
    dv.stack.each do |item|
      root_id = item.keys[0]
      data = item[root_id]
      doc_id = data[2]
      doc_title = data[1]
      # root_title = data[0]
      output << "<li> <a href='/#{view_mode}/#{doc_id}'>#{doc_title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end


end