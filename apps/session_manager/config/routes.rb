post '/update_settings', to: 'settings#update'
get '/settings', to: 'settings#edit'
get '/logout', to: 'user#logout'
post '/authenticate', to: 'user#authenticate'
get '/login', to: 'user#login'
post '/create_user', to: 'user#create'
get '/new_user', to: 'user#new'
# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage