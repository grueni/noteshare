class NodePresenter


  def initialize(node, user)
    @node = node
    if @node
      puts "@node = #{@node.name}".red
    else
      puts "@node is NIL".red
    end
    @user = user
    @user ? @docs = @node.documents_readable_by(@user) : @docs = @node.public_documents
    @docs = @docs.sort_by_title
  end

  def readable_documents
    @docs
  end

  def number_of_readable_documents
    if @docs
      return @docs.count
    else
      0
    end
  end

  def html_list(docs, view_mode)
    output = "<ul>\n"
    @docs.each do |doc|
      output << "<li class='ns_link'> <a href='/#{view_mode}/#{doc.id}'>#{doc.title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  def blurb
    if @node.meta && @node.meta['rendered_blurb']
      @node.meta['rendered_blurb']
    else
      text = ''
      text << '<img src="http://s3.amazonaws.com/vschool/noteshare_images/111129135500aR7j-original.jpg" width=60% style="margin-top:1em; float:right; "/>'
    end
  end

  # Return an HTML list of links to documents
  def documents_as_list(option)
    return '' if @docs == []
    case option
      when :titlepage
        html_list(@docs, 'titlepage')
      when :sidebar
        html_list(@docs, 'aside')
      when :view_source
        html_list(@docs, 'view_source')
      when :compiled
        html_list(@docs, 'compiled')
      else
        html_list(@docs, 'document')
    end
  end

  def neighboring_nodes_list
    Neighbors.new(node: @node).html_list
  end

  def sidebar
    html = '<h4>Nearby nodes</h4>'
    html << neighboring_nodes_list || ''
    meta = @node.meta['rendered_sidebar_text']
    html << meta if meta != nil
    html
  end

  def recently_viewed(view_mode)
    DocumentActivityManager.new(nil, @user).list(view_mode)
  end

  def recent_nodes
    NodeActivityManager.new(user: @user).list
  end


end