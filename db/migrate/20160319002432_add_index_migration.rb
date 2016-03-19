class AddIndexMigration < ActiveRecord::Migration
  def change
  	add_index :contacts, :email
  end
end
