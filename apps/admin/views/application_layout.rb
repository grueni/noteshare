module Admin
  module Views
    class ApplicationLayout
      include Admin::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links



      def command_input_form
        form_for :command_processor, '/admin/process_command' do
          text_field :command, {id: 'command_form', style: 'margin-left:0;'}
          hidden_field :secret_token, value: ENV['COMMAND_SECRET_TOKEN'], placeholder: 'command'
          submit 'Execute',  class: "waves-effect waves-light btn", style: 'margin-top:3em;'
        end



      #####################################################
      #
      #   4. ADMIN LINKS
      #
      #####################################################

      def update_message_link
        link_to 'Sys message', '/admin/update_message'
      end

      def delete_user_link(id)
        link_to 'delete', "/admin/delete_user/#{id}"
      end

      def admin_delete_document_link(id)
        link_to 'delete', "/admin/delete_document/#{id}"
      end

      def upload_file_link
        link_to 'Upload', "/uploader/file"
      end

      def user_node_link(user)
        link_to user.screen_name, "/node/#{user.node_id}"
      end

      def admin_analytics_link(session, active_item='')
        active_item == 'admin' ? css_class = 'active_item' : ''
        cu = current_user(session)
        return ''  if cu == nil
        text_link(title: 'Analytics', prefix: cu.node_name , suffix: 'admin/analytics', class: css_class)
      end

      def admin_manual_link(session)
        cu = current_user(session)
        cu ? prefix = cu.node_name : prefix = :none
        return text_link(prefix: prefix, suffix: "document/#{ENV['ADMIN_MANUAL_DOC_ID']}", title: 'A', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
        # link_to "G",  "document/#{ENV['USER_GUIDE_DOC_ID']}",  class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;'

      end

      def admin_manual_link_long(session)
        cu = current_user(session)
        cu ? prefix = cu.node_name : prefix = :none
        return text_link(prefix: prefix, suffix: "document/#{ENV['ADMIN_MANUAL_DOC_ID']}", title: "Administrator's manual")
        # link_to 'User Guide', "/document/#{ENV['USER_GUIDE_DOC_ID']}"
      end

      end
    end
  end
end
