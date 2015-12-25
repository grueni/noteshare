module Node::Views::Admin
  class Edit
    include Node::View

    def form

      form_for :node, "/node/update/#{node.id}" do

        label :dictionary
        text_area :dictionary,  node.dict.string_val(:vertical)

        hidden_field :node_id, value: node.id

        submit 'Update',  class: "waves-effect waves-light btn"

      end
    end
  end
end
