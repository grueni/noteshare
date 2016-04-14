module Noteshare
  module Core
    module Node
      class NSNodeRepository
        include Lotus::Repository

        def self.search(key, limit: 20)
          array = fetch("SELECT id FROM nodes WHERE name ILIKE '%#{key}%' OR tags ILIKE '%#{key}%';")
          array = array.map{ |h| h[:id] }.uniq
          array.map{ |id| NSNodeRepository.find id }.sort_by { |item| item.name }
        end

        # Get rid of this.  It doesn't do what it says
        def self.public
          array = fetch("SELECT id FROM nodes WHERE type = 'public';")
          array = array.map{ |h| h[:id] }.uniq
          array.map{ |id| NSNodeRepository.find id }.sort_by { |item| item.name }
        end

        def self.personal
          array = fetch("SELECT id FROM nodes WHERE type = 'personal';")
          array = array.map{ |h| h[:id] }.uniq
          array.map{ |id| NSNodeRepository.find id }.sort_by { |item| item.name }
        end

        def self.find_by_name(name)
          query do
            where(name: name)
          end
        end

        def self.find_one_by_name(name)
          self.find_by_name(name).first
        end

        def self.for_owner_id_aux(owner_id)
          query do
            where(owner_id: owner_id)
          end
        end

        def self.for_owner_id(owner_id)
          result = self.for_owner_id_aux(owner_id)
          result.first
        end


      end
    end
  end
end

