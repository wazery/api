class HackerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :avatar_url, :display_name
end
