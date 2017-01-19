class CreateShops < ActiveRecord::Migration[4.2]
  def up
    create_table :shops do |t|
      t.string :name, null: false
      t.string :contents, null: false
      t.timestamps null: false
    end
  end

  def down
    drop_table :shops
  end
end
