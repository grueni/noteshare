get '/aside/:id', to: 'documents#aside'
get '/titlepage/:id', to: 'documents#titlepage'
get '/', to: 'home#switchboard'

get '/about', to: 'home#about'


get '/home', to: 'home#index'

get '/document/:id', to: 'documents#show'
get '/compiled/:id', to: 'documents#show_compiled'

get '/documents', to: 'documents#index'

post '/search', to: 'documents#search'

# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage

