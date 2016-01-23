# apps/web/controllers/home/index.rb

module Admin::Controllers::Home
  class Index
    include Admin::Action

    expose :active_item

    def call(params)
      puts "current_user2: #{current_user2}".red
      redirect_if_not_admin('Attempt to list documents (admin, home, index)')
      @active_item = 'admin'
      @page_views = Analytics.get_keen_data(query_type: 'count', collection: 'page_views')
    end

  end
end
