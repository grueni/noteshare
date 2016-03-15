  class Neighbor

    def initialize(data)
      @data = data || {}
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
      @array if @arr == nil
      @array.sort_by{ |item| item[1]}
    end

    def sort_descending
      @array if @arr == nil
      @array.sort_by{ |item| -item[1]}
    end

    def html_list
      sort_descending
      html =  "<ul>\n"
      @array.each do |item|
        html << "<li class='ns_link'> <a href='/node/#{item[0]}'>#{item[0]}</a></li>\n"
      end
      html
    end


  end