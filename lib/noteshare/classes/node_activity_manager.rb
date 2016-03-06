
# ActivityManager records
# the documents a user
# views and can present
# a list of this activity
class NodeActivityManager



  def initialize(node, user)
    @node = node
    @user = user
  end

  def record
    return if @user == nil
    array = @user.nodes_visited
    nv = NodesVisited.new(array, ENV['DOCS_VISITED_CAPACITY'])
    nv.push_node(@node)
    @user.nodes_visited = nv.stack
    UserRepository.update @user
  end


  # @document can be nil for this method:
  def list
    array = @user.nodes_visited || []
    array = array.reverse
    nv = NodesVisited.new(array, ENV['NODES_VISITED_CAPACITY'])
    output = "<ul>\n"
    nv.stack.each do |item|
      node_id = item.keys[0]
      data = item[node_id]
      node_name = data[0]
      output << "<li> <a href='/node/#{node_id}'>#{node_name}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end


end