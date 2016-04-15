require 'bcrypt'


module HR
  module Core

    class UserRepository
      include Lotus::Repository

      def self.find_by_email(email)
        query do
          where(email: email)
        end
      end

      def self.find_one_by_email(email)
        result = self.find_by_email(email)
        return result.first if result
      end

      def self.find_by_screen_name(name)
        query do
          where(screen_name: name)
        end
      end

      def self.find_one_by_screen_name(name)
        result = self.find_by_screen_name(name)
        return result.first if result
      end


    end

  end
end
