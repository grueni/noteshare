module Editor::Controllers::Document
  class ManagePublications
    include Editor::Action

    def call(params)
      redirect_if_not_signed_in('editor, document, CreateNewSection')
      record_id = params['id']
      command_string = request.query_string
      Publications.execute_command(command_string, record_id)
      redirect_to '/admin/publications'
      # self.body = "record_id: #{record_id}, command_string = #{command_string}"
    end
  end
end
