get '/manage_overlay/:id', to: 'public#manage_overlay'
get '/set_publisher/:id', to: 'admin#set_publisher'
post '/update_sidebar/:id', to: 'admin#update_sidebar'
get '/edit_sidebar/:id', to: 'admin#edit_sidebar'
post '/update_blurb/:id', to: 'admin#update_blurb'
get '/edit_blurb/:id', to: 'admin#edit_blurb'
get '/remove_document/:id', to: 'user#remove'
get '/manage/:id', to: 'user#manage'
post '/update/:id', to: 'admin#update'
get '/edit/:id', to: 'admin#edit'
post '/create', to: 'admin#create'
get '/new', to: 'admin#new'

get '/public', to: 'public#list'

get '/settings', to: 'settings#edit'
get '/admin', to: 'admin#list'
get '/user/:id', to: 'user#show'
get '/:id', to: 'public#show'

# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage