require 'lotus/interactor'
# require '../../classes/node/node_presenter'
# require '../../../noteshare/classes/node/node_activity_manager'

module Noteshare
  module Interactor
    module Node
      class PublicShow

        include Lotus::Interactor
        include Noteshare::Presenter::Node
        include Noteshare::Helper::Node
        include Noteshare::Core::Node

        expose :node, :user, :active_item, :layout_option, :blurb_text, :rendered_text,
               :sidebar_text, :rendered_sidebar_text, :presenter, :show_overlay

        def initialize(hash)
          @node = NSNode.get_node(hash[:node_name])
          puts "Interactor public_show, node = #{@node.name}".red
          @user = hash[:user]
        end


        def call
          @active_item = 'documents'

          if @user
            @show_overlay =  (@node.name == 'start') && (@user.dict2['show_overlay'] == 'yes')
            @show_overlay = @show_overlay &&  (@user.dict2['show_overlay_this_session'] == 'yes') # && (current_user2.id == 9)
          else
            @show_overlay = false
          end

          return if @node == nil
          # ^^ Fixme: better, go to error page
          if @user
            @user.set_current_node(@user, @node)
          end

          NodeActivityManager.new(node: @node, user: @user).record
          @presenter = NodePresenter.new(@node, @user)

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

          @node.update
        end

      end

    end
  end
end

