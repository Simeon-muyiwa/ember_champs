class CreateRecipeDiets < ActiveRecord::Migration
  def change
    create_table :recipe_diets do |t|
      t.references :diet, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :recipe_diets, [:diet_id, :recipe_id]
  end
end
