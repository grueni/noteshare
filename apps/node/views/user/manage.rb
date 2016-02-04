module Node::Views::User
  class Manage
    include Node::View

    def add_document_to_node_form

      form_for :admin, '/admin/add_document_to_node', method: :post, remote: true  do


        hidden_field :node_id, value: current_node.id

        label :document_id_or_title
        text_field :document_id, class: 'plain'

        submit 'add'

      end
    end

    def edit_user_node_link
      # prefix = node.name
      # text_link(prefix: prefix, suffix: "node/manage/#{current_node.id}", title: node.name)
      link_to 'Edit node', "node/manage/#{current_node.id}"
    end

  end
end
