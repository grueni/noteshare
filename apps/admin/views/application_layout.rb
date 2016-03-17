module Admin
  module Views
    class ApplicationLayout
      include Admin::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links

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
        prefix = get_prefix(session)
        text_link(title: 'Analytics', prefix: prefix , suffix: 'admin/analytics', class: css_class)
      end

      def admin_manual_link(session)
        prefix = get_prefix(session)
        return text_link(prefix: prefix, suffix: "document/#{ENV['ADMIN_MANUAL_DOC_ID']}", title: 'Admin Manual', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
      end

      def admin_manual_link_long(session)
        prefix=get_prefix(session)
        return text_link(prefix: prefix, suffix: "document/#{ENV['ADMIN_MANUAL_DOC_ID']}", title: "Administrator's manual")
      end

      end
    end
  end

