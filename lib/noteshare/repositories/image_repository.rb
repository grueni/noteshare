class ImageRepository
  include Lotus::Repository

  def self.basic_search(key, limit: 8)
    fetch("SELECT id FROM images WHERE title ILIKE '%#{key}%' OR tags ILIKE '%#{key}%';")
  end


  def self.search(key, limit: 8)
    self.basic_search(key, limit: 8).map{ |h| ImageRepository.find(h[:id]) }
  end

  def self.search3(key, limit: 8)
    if key == nil
      puts "1".magenta
      @images = ImageRepository.all.random_sublist(6)
    elsif key == ''
      puts "2".magenta
      @images = ImageRepository.all.random_sublist(6)
    else
      puts "3".magenta
      @images = self.search(key, limit: 8)
    end
  end

  def self.search2(title, limit: 8)
    query do
      where(title: title)
      order(:created_at)
    end.limit(limit)
  end

end
