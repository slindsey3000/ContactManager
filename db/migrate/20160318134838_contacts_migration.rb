class ContactsMigration < ActiveRecord::Migration
  def change
  	create_table :contacts do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :phone
    end  
  end
end
