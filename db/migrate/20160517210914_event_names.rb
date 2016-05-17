class EventNames < ActiveRecord::Migration
  def change
    create_table :event_names do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
