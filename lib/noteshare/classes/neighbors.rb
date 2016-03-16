  class Neighbors

    def initialize(hash)
       if hash[:data]
        @data = data || {}
      elsif hash[:node]
        @node = hash[:node]
        @data = @node.neighbors || {}
       elsif hash[:nodename]
         @node = NSNodeRepository.find_one_by_name hash[:nodename]
         @data = @node.neighbors || {}
       else
        @data = {}
      end
    end

    def save
      if @node
        @node.neighbors = @data
        NSNodeRepository.update @node
      end
    end

    def add(name, strength)
      hash = { 'strength' => strength }
      if @data[name] == nil
        @data[name] = hash
      else
        @data[name]['strength'] = strength
      end
    end

    def data
      @data
    end

    def remove(name)
      @data.delete(name)
    end

    def nodes
      @data.keys
    end

    def display
      puts @data.inspect
    end

    def make_array
      @array = []
      @data.each do |name, value|
        @array << [name, value['strength']]
      end
      @array
    end

    def array
      make_array if @array == nil
      @array
    end

    def sort_ascending
      array if @array == nil
      @array = @array.sort_by{ |item| item[1]}
    end

    def sort_descending
      array if @array == nil
      @array = @array.sort_by{ |item| -item[1]}
    end

    def html_list
      sort_descending
      html =  "<ul>\n"
      @array.each do |item|
        html << "<li class='ns_link'> <a href='/node/#{item[0]}'>#{item[0]}</a></li>\n"
      end
      html << "</ul>\n\n"
      html
    end


  end