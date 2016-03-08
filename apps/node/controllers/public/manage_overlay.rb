module Node::Controllers::Public
  class ManageOverlay
    include Node::Action

    def call(params)
      query_string = request.query_string
      id = params['id']
      referer = request.env["HTTP_REFERER"]

      @user = current_user(session)

      case query_string
        when 'turn_overlay_off'
          @user.dict2['show_overlay_this_session'] = 'no'
        when 'turn_overlay_on'
          @user.dict2['show_overlay_this_session'] = 'yes'
        when 'turn_overlay_off_forever'
          @user.dict2['show_overlay'] = 'no'
        when 'turn_overlay_on_forever'
          @user.dict2['show_overlay'] = 'yes'
      end
      UserRepository.update @user
      back_link = referer.split('?')[0]
      redirect_to back_link
      # self.body = "#{id} <== #{query_string}.  Referred by #{referer} from user #{@user.full_name}"
    end
  end
end
