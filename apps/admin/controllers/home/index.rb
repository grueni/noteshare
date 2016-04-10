# apps/web/controllers/home/index.rb

module Admin::Controllers::Home
  class Index
    include Admin::Action
    include Noteshare::Core::Yada

    expose :active_item

    def call(params)
      redirect_if_not_admin('Attempt to list documents (admin, home, index)')
      foo_instance = Foo.new('Howdy')
      foo_instance.display
      @active_item = 'admin'
      @page_views = Analytics.get_keen_data(query_type: 'count', collection: 'page_views')
    end

  end
end
