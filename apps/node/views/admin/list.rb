module Node::Views::Admin
  class List
    include Node::View

    def add_document_to_node_form

      form_for :admin, '/admin/add_document_to_node', method: :post, remote: true    do

        label :node_id
        text_field :node_id, class: 'plain'

        label :document_id
        text_field :document_id, class: 'plain'

        submit 'add'

      end

    end


  end
end
