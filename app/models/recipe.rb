class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :recipe_diets, dependent: :destroy
  has_many :diets, through: :recipe_diets
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  validates :user_id, presence: true
  validates :name, presence: true, length: {minimum: 5, maximum: 100 }
  validates :summary, presence: true, length: {minimum: 10, maximum: 150 }
  validates :description, presence: true, length: {minimum: 20, maximum: 500 }
  mount_uploader :picture,  PictureUploader
  validate  :picture_size
  default_scope -> { order(updated_at: :desc) }



  def thumbs_up_total
    self.likes.where(like: true).count
  end
  
  def thumbs_down_total
    self.likes.where(like: false).count   
  end


  private
  #validates the size of an uploaded picture.
  def picture_size
  	if picture.size > 5.megabytes
  		errors.add(:picture, "should be less than 5MB")
    end
  end

end
