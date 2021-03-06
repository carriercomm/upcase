class AddPublicToExercises < ActiveRecord::Migration
  def up
    add_column :exercises, :public, :boolean, null: false, default: false
    update("UPDATE exercises SET public = true")
    add_index :exercises, :public
  end

  def down
    remove_column :exercises, :public
  end
end
