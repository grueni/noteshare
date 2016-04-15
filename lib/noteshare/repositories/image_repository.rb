module Noteshare
  module Core
    module Image
      class ImageRepository
        include Lotus::Repository

        # Find all objects with a gvien title
        def self.find_by_title(title)
          query do
            where(title: title)
          end
        end

        def self.find_by_id(id)
          query do
            where(id: id)
          end
        end

        def self.find_one_by_title(title)
          find_by_title(title).first
        end

        def self.basic_search(key, limit: 16)
          fetch("SELECT id FROM ns_images WHERE title ILIKE '%#{key}%' OR tags ILIKE '%#{key}%';")
        end

        def self.search(key, limit: 16)
          key = key.strip
          if key.is_integer?
            self.find_by_id(key)
          else
            self.basic_search(key, limit: 16).map{ |h| ImageRepository.find(h[:id]) }
          end
        end

        def self.search3(key, limit: 8)
          if key == nil
            @images = ImageRepository.all.random_sublist(16)
          elsif key == ''
            @images = ImageRepository.all.random_sublist(16)
          else
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

    end
  end
end


