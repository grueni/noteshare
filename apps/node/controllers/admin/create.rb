module Node::Controllers::Admin
  class Create
    include Node::Action

    def call(params)
      node_info = params['new_node']

      name = node_info['name']
      owner_id = node_info['owner_id']
      type = node_info['type']
      tags = node_info['tags']

      NSNode.create(name, owner_id, type, tags)

      redirect_to  '/node/admin/'
    end

  end
end
