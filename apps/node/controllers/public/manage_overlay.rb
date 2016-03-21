module Node::Controllers::Public
  class ManageOverlay
    include Node::Action

    def call(params)
      query_string = request.query_string
      id = params['id']
      referer = request.env["HTTP_REFERER"]
      

      case query_string
        when 'turn_overlay_off'
          current_user2.dict2['show_overlay_this_session'] = 'no'
        when 'turn_overlay_on'
          current_user2.dict2['show_overlay_this_session'] = 'yes'
        when 'turn_overlay_off_forever'
          current_user2.dict2['show_overlay'] = 'no'
        when 'turn_overlay_on_forever'
          current_user2.dict2['show_overlay'] = 'yes'
      end
      UserRepository.update current_user2
      back_link = referer.split('?')[0]
      redirect_to back_link
      # self.body = "#{id} <== #{query_string}.  Referred by #{referer} from user #{current_user2.full_name}"
    end
  end
end
