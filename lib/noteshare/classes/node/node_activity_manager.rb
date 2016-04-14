
# ActivityManager records
# the documents a user
# views and can present
# a list of this activity
include Noteshare::Helper::Node
class NodeActivityManager


  attr_reader :last_node_id, :last_node_name

  def initialize(hash)
    @node = hash[:node]
    @user = hash[:user]
  end

  def record
    return if @user == nil
    if @node.name != 'start' && @node.name != @user.node.name
      push(@node)
    end
  end

  def push_default
    default_node = NSNodeRepository.find_one_by_name(ENV['DEFAULT_LAST_NODE_ID'])
    push(default_node)
  end


  def configure
    array = @user.nodes_visited || []
    if array == []
      push_default
      array = @user.nodes_visited
    end
    @object = NodesVisited.new(array, ENV['NODES_VISITED_CAPACITY'])
    @stack = @object.stack
    last_item = @stack.last
    if last_item
      @last_node_id = last_item.keys[0]
      @last_node_name = last_item.values[0][0]
    end
  end


  # @document can be nil for this method:
  def list
    configure
    output = "<ul>\n"
    @stack.reverse.each do |item|
      node_id = item.keys[0]
      data = item[node_id]
      node_name = data[0]
      output << "<li class='ns_link'> <a href='/node/#{node_name}'>#{node_name}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  def last_node
   stack.last
  end

  private

  def push(node)
    array = @user.nodes_visited
    nv = NodesVisited.new(array, ENV['DOCS_VISITED_CAPACITY'])
    nv.push_node(node)
    @user.nodes_visited = nv.stack
    UserRepository.update @user
  end

end