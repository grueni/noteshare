module Editor::Controllers::Documents
  class New
    include Editor::Action

    expose :document

    def call(params)

      puts "Trying to save  params[:id] (#{params[:id]}) in params[:parent_id]"
      # params[:parent_id] = params[:id]

    end
  end

end
