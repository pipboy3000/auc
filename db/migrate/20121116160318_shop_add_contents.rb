class ShopAddContents < ActiveRecord::Migration[4.2]
  def up
    change_table :shops do |t|
      t.rename :contents, :contents1
    end
    (2..9).each do |i|
      add_column :shops, "contents#{i}".to_sym, :string
    end
  end

  def down
    change_table :shops do |t|
      t.rename :contents1, :contents
    end
    (2..9).each do |i|
      remove_column :shops, "contents#{i}".to_sym, :string
    end
  end
end
