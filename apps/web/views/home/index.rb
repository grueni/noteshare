module Web::Views::Home
  class Index
    include Web::View

    def current_domain_name
      ENV['DOMAIN'].sub(/^\./,'')
    end

  end
end