module Node::Controllers::Public
  class Show
    include Node::Action

    expose :node, :active_item, :layout_option

    def call(params)
      @active_item = 'documents'
      @node = NSNodeRepository.find params[:id]
      return if @node == nil
      # ^^ Fixme: better, go to error page
      cookies[:current_node_id] = @node.id
      puts "In  Node::Controllers::Public, Show, cookies[:current_node_id] = #{cookies[:current_node_id]}".red
      if @node.dict['layout'] == 'simple_sidebar'
        @layout_option = :sidebar
      else
        @layout_option = :titlepage
      end
    end

  end
end
