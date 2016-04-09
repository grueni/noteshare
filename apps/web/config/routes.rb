get '/choose_view/:id', to: 'document#choose_view'
# get '/documents', to: 'documents#set_search_type'
get '/link/:id', to: 'document#link'
get '/view_source/:id', to: 'documents#view_source'
post '/set_search_type', to: 'documents#set_search_type'
get '/error/:id', to: 'home#error'
get '/error', to: 'home#error'
get '/aside/:id', to: 'documents#aside'

get '/titlepage/:id', to: 'documents#titlepage'
get '/titlepage', to: 'home#error'

get '/', to: 'home#switchboard'

get '/about', to: 'home#about'


get '/home', to: 'home#index'

get '/document/:id', to: 'documents#show'
get '/compiled/:id', to: 'documents#show_compiled'

get '/documents', to: 'documents#index'

post '/search', to: 'documents#search'


# See: http://www.rubydoc.info/gems/lotus-router/#Usage

