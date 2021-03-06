class Api::V1::PostSerializer < Api::V1::BaseSerializer
  attributes :id, :content, :picture, :created_at, :updated_at

  has_one :user

  def picture
    object.picture.url
  end
end

