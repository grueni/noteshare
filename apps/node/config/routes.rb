get '/settings', to: 'settings#edit'
get '/:id', to: 'public#show'
get '/admin', to: 'admin#list'
get '/user/:id', to: 'user#show'

# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage