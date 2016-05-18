class CreateUserAgents < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.string :os
      t.string :browser

      t.timestamps null: false
    end
  end
end
