get '/update', to: 'image#update'
get '/show/:id', to: 'image#show'
get '/search', to: 'image#search'
get '/list', to: 'image#list'
get '/new', to: 'image#new'
post '/upload', to: 'image#upload'
# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage