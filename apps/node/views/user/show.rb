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

  end
end
