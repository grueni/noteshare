module Analytics

  def self.record_page_visit(user, document)
    puts "analytics".red
    if user
      if !user.admin
        Keen.publish(:document_views, { :username => user.screen_name,
                                        :document => document.title, :document_id => document.id })
      end
    else
      Keen.publish(:document_views, { :username => 'anonymous',
                                      :document => document.title, :document_id => @ocument.id })
    end
  end





end