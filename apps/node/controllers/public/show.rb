
module Node::Controllers::Public


  class Show
    include Node::Action
    include Noteshare::Interactor::Node

    expose :node, :user, :active_item, :layout_option, :blurb_text, :rendered_text,
    :sidebar_text, :rendered_sidebar_text, :presenter, :show_overlay

    def call(params)

      puts "In controller Public Show, node_id = #{params[:id]}".red
      result = PublicShow.new(user: current_user2, node_id: params[:id]).call
      @node = result.node
      @user = result.user
      @active_item = result.active_item
      @layout_option = result.layout_option
      @blurb_text = result.blurb_text
      @rendered_text = result.rendered_text
      @sidebar_text = result.sidebar_text
      @rendered_sidebar_text = result.rendered_sidebar_text
      @presenter = result.presenter
      @show_overlay = result.show_overlay

    end

  end
end
