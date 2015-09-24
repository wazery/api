class HackerSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :avatar_url, :display_name
end
