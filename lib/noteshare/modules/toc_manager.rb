
### INTERFACE
#   move_section_to_sibling_of_parent
class TOCManager

  def initialize(document)
    @document = document
  end

  def move_section_to_sibling_of_parent
    gp = @document.grandparent_document
    p = @document.parent_document
    k = p.index_in_parent
    if gp && gp != parent_document
      @document.remove_from_parent
      @document.insert(k+1, gp)
      return gp
    else
      puts 'grand parent iS parent'.cyan
      return @document.parent_document
    end
  end


end