
module UserGroup
  module Core
    class GroupsRepository
      include Lotus::Repository

      def self.find_by_name(name)
        query do
          where(name: name)
        end
      end
    end
  end
end


