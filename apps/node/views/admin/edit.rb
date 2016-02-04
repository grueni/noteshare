module Node::Views::Admin
  class Edit
    include Node::View

    def form

      edit_text = node.dict.string_val(:vertical) << "\n" << node.publication_records_as_string << "\n"
      # edit_text << 'docs: ' << node.documents_as_string

      form_for :node, "/node/update/#{node.id}" do

        label :dictionary
        text_area :dictionary,  edit_text

        hidden_field :node_id, value: node.id

        submit 'Update',  class: "waves-effect waves-light btn"

      end
    end

  end
end
