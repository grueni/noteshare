get '/search', to: 'documents#search'
post '/search', to: 'documents#search'
post '/process_command', to: 'home#process_command'
get '/publications', to: 'publications#manage'
get '/courses', to: 'course#find'
get '/analytics', to: 'home#show_analytics'
get '/delete_document/:id', to: 'documents#delete'
get '/delete_user/:id', to: 'users#delete'

get '/node', to: 'node#add_document'
post '/add_document_to_node', to: 'node#add_document'

get '/course/import', to: 'course#import'
post '/course/do_import', to: 'course#do_import'

post '/do_update_message', to: 'settings#do_update_message'
get '/update_message', to: 'settings#update'
get '/documents', to: 'documents#list'
get '/', to: 'home#index'
get '/users', to: 'users#list'
# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage