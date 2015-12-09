module Editor::Controllers::Documents
  class New
    include Editor::Action

    expose :document
    expose :active_item

    def call(params)
      @active_item = 'editor'
      puts "controller new xxxx".red
      puts "Trying to save  params[:id] (#{params[:id]}) in params[:parent_id]"
      # params[:parent_id] = params[:id]

    end
  end

end
