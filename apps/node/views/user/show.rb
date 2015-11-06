module Node::Views::User
  class Show
    include Node::View

    def title(node)
      "Node #{node.name}"
    end

    def owner_line(node)
      user = UserRepository.find(node.owner_id)
      "This is #{user.screen_name}'s node" if user
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
