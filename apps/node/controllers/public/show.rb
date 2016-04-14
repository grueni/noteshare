
module Node::Controllers::Public


  class Show
    include Node::Action
    include NodeMapper
    include Noteshare::Presenter::Node
    include Noteshare::Helper::Node

    expose :node, :user, :active_item, :layout_option, :blurb_text, :rendered_text
    expose :sidebar_text, :rendered_sidebar_text, :presenter, :show_overlay

    def call(params)

      @active_item = 'documents'

      # @node = NSNodeRepository.find params[:id]
      # @node = NSNodeRepository.find NodeMapper.new(params[:id]).translate
      @node = get_node(params[:id])

      @user = current_user2

      if current_user2
        @show_overlay =  (@node.name == 'start') && (current_user2.dict2['show_overlay'] == 'yes')
        @show_overlay = @show_overlay &&  (current_user2.dict2['show_overlay_this_session'] == 'yes') # && (current_user2.id == 9)
      else
        @show_overlay = false
      end

      return if @node == nil
      # ^^ Fixme: better, go to error page
      if current_user2
        current_user2.set_current_node(current_user2, @node)
      end

      NodeActivityManager.new(node: @node, user: current_user2).record
      @presenter = NodePresenter.new(@node, current_user2)

      puts "layout = #{@node.dict['layout']}"

      case @node.dict['layout']
        when 'simple_sidebar'
          @layout_option = :sidebar
        when 'titlepage'
          @layout_option = :titlepage
        when 'view_source'
          @layout_option = :view_source
        else
          @layout_option = :titlepage
      end

      @node.meta = {} if @node.meta == nil

      @blurb_text =  @node.meta['long_blurb'] || ''
      @rendered_blurb = @node.meta['rendered-blurb'] || ''

      @sidebar_text =  @node.meta['sidebar_text'] || ''
      # @rendered_sidebar_text = @node.meta['rendered_sidebar_text'] || ''
      @rendered_sidebar_text = @presenter.sidebar

      NSNodeRepository.update @node

    end

  end
end
