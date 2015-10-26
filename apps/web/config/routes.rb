get '/documents', to: 'documents#search'

get '/', to: 'home#index'

get '/document/:id', to: 'documents#show'
get '/documents', to: 'documents#index'

# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage

