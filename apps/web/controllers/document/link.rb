module Web::Controllers::Document
  class Link
    include Web::Action

    def call(params)

      if current_user(session)
        screen_name = current_user(session).screen_name
      else
        screen_name = 'www'
      end

      id = params['id']
      reference = request.query_string

      if reference && reference != ""
        puts "using reference".cyan
        new_link = basic_link screen_name, "document/#{id}\##{reference}"
      else
        puts "no reference".cyan
        new_link = basic_link screen_name, "document/#{id}"
      end

      puts "NEW LINK: #{new_link}".red

      redirect_to new_link
    end

  end

end
