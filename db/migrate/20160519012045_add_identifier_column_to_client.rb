class AddIdentifierColumnToClient < ActiveRecord::Migration
  def change
    add_column :clients, :identifier, :string
  end
end
