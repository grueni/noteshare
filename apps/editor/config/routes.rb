
# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage

get '/', to: 'home#index'
get '/new', to: 'documents#new'
get '/documents', to: 'documents#index'
post '/documents', to: 'documents#create'
get '/document/:id', to: 'document#edit'