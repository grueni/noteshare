require_relative '../../../../lib/noteshare/interactors/node/update_node'

module Node::Controllers::Admin
  class Update
    include Node::Action

    expose :node, :active_item

    def call(params)
      @active_item = 'admin'
      data = params['node']
      node_id  = data['node_id']
      dictionary = data['dictionary']
      result = Noteshare::Interactor::Node::UpdateNode.new(node_id, dictionary).call
      @node = result.node
      redirect_to "/node/#{node_id}"
    end

  end
end
