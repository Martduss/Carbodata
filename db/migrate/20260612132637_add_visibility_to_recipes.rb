class AddVisibilityToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :visibility, :integer, default: 0, null: false
    add_index :recipes, :visibility
  end
end
