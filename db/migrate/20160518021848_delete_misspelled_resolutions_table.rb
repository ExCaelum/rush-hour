class DeleteMisspelledResolutionsTable < ActiveRecord::Migration
  def change
    drop_table :reslutions
  end
end
