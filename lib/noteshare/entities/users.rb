class Users
  include Lotus::Entity
  attributes :id, :first_name, :last_name, :email, :screen_name, :level
end
