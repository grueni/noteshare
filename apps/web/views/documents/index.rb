module Web::Views::Documents
  class Index
    include Web::View

    def foo
      html.tag(:a, 'Foo', href: 'http://nytimes.com')
    end

    def foo1
      html.span do
        'La di dah'
      end
    end

  end
end
