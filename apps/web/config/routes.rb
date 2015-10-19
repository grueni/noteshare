
get '/', to: 'home#index'

get '/new', to: 'documents#new'
get '/show', to: 'documents#show'
get '/documents', to: 'documents#index'

# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage

