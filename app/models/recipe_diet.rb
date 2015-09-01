class RecipeDiet < ActiveRecord::Base
  belongs_to :diet
  belongs_to :recipe
end
