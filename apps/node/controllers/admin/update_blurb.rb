require_relative '../../../../lib/noteshare/interactors/node/update_node_blurb'


module Node::Controllers::Admin
  class UpdateBlurb
    include Node::Action

    def call(params)
      blurb_text = params['node']['blurb'] || ''
      node_id =params['id']
      Noteshare::Interactor::Node::UpdateNodeBlurb.new(node_id, blurb_text ).call
      redirect_to basic_link current_user2.screen_name, "node/#{node_id}"
    end

  end
end
