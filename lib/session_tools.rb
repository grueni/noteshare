
module HR
  module Core

    require 'keen'
    module SessionTools
      include Keen

      def logout(user, session)
        if user
          user.remember_current_document_id(session)
          UserRepository.update user
        end
        session[:current_document_id] = nil
        session[:current_image_id] = nil
        session[:user_id] = nil
      end

      def current_user(session)
        UserRepository.find session[:user_id]
      end

      def current_user_id(session)
        if current_user(session)
          return current_user.id
        else
          return nil
        end
      end

      def current_user_is_admin?(session)
        user = UserRepository.find session[:user_id]
        return false if user == nil
        return user.admin
      end

      def current_user_full_name(session)
        user = UserRepository.find session[:user_id]
        "#{user.first_name} #{user.last_name}"
      end

      # See
      #    http://lotusrb.org/guides/actions/share-code/
      # for a better solution
      def redirect_if_not_admin(message)
        cu = current_user(session)
        if cu == nil or cu.admin == false
          if cu == nil
            Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
          else
            Keen.publish(:unauthorized_access_attempt, {user: cu.screen_name, message: message})
          end
          # redirect_to '/error/0?Something went wrong.'
          halt(401)
        end
      end

      def redirect_if_not_signed_in(message)
        cu = current_user(session)
        if cu == nil
          Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
          # redirect_to '/error/1?Something went wrong.'
          halt(401)
        end
      end


      def redirect_if_level_insufficient(level, message)
        cu = current_user(session)
        if cu == nil
          Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
          halt(401)
        end
        if cu.level == nil || cu.level < level
          Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
          halt(401)
        end
      end

      def redirect_if_document_not_public(document, message)
        cu = current_user(session)
        world_permission = document.acl_get(:world)
        if cu == nil && !(world_permission =~ /r/)
          Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
          halt(401)
        end
      end


    end


  end
end


