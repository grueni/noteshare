post '/do_update_message', to: 'settings#do_update_message'
get '/update_message', to: 'settings#update'
get '/documents', to: 'documents#list'
get '/', to: 'home#index'
get '/users', to: 'users#list'
# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage