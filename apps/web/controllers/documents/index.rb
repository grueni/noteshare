module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents

    def call(params)
      puts "\n\nYYYYYY"
      puts params.inspect
      puts "YYYYYY\n\n"
      # redirect_to '/documents'
    end

  end
end
