### TOCManager
#   used to move document around
#   in the table of contents
### INTERFACE
#   move_section_to_sibling_of_parent
#   move_section_to_parent_level
#   move_up_in_toc
#   move_down_in_toc
#   make_child_of_sibling
class TOCManager

  def initialize(document)
    @document = document
  end

  def move_section_to_sibling_of_parent
    gp = @document.grandparent_document
    p = @document.parent_document
    k = p.index_in_parent
    if gp && gp != p
      @document.remove_from_parent
      @document.insert(k+1, gp)
      return gp
    else
      puts 'grand parent iS parent'.cyan
      return @document.parent_document
    end
  end

  # ONLY IN TESTS
  def move_section_to_parent_level
    gp = @document.grandparent_document
    if gp && gp != @document.parent_document
      @document.remove_from_parent
      @document.add_to(gp)
      return gp
    else
      puts 'grand parent is parent'.cyan
      return @document.parent_document
    end
  end


  def move_up_in_toc
    p = @document.previous_document
    sibling_swap_in_toc(p) if p
  end

  def move_down_in_toc
    n = @document.next_document
    sibling_swap_in_toc(n) if n
  end

  def permute_table_of_contents(permutation)
    toc2 = @document.toc.permute(permutation)
    @document.toc = toc2
    DocumentRepository.update @document
  end

  # PUBLIC
  def make_child_of_sibling
    p = @document.previous_document
    if p
      @document.remove_from_parent
      @document.add_to(p)
    end
  end

  ### PRIVATE ###

  def sibling_swap_in_toc(other_document)
    p = @document.parent_document
    _toc = TOC.new(p)
    _toc.swap(@document, other_document)
  end


end