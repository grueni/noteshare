module Node::Views::User
  class Show
    include Node::View

    def title(node)
      if node
        "Node #{node.name}"
      else
        "No node set up"
      end
    end

    def owner_line(node)
      if node
        user = UserRepository.find(node.owner_id)
        "This is #{user.screen_name}'s node" if user
      else
        ""
      end
    end

=begin
    def doclist(node)
      ul
      documents.each do |doc|
        li == document_link(doc)
    end

=end

  end

end
