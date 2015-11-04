class User
  include Lotus::Entity
  attributes :id, :first_name, :last_name, :email, :screen_name, :level, :password, :password_confirmation
end
