module NodeMapper


  def get_node(id)
    if id =~ /\A\d*\z/
      NSNodeRepository.find id
    else
      NSNodeRepository.find_one_by_name id
    end
  end

end