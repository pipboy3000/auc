class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username
      t.string :crypted_password
      t.string :salt
      t.timestamps null: false
    end
  end

  def down
    drop_table :users
  end
end
