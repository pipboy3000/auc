class ShopContentsStringToText < ActiveRecord::Migration
  def up
    (1..9).each do |i|
      change_column :shops, "contents#{i}".to_sym, :text
    end
  end

  def down
    (1..9).each do |i|
      change_column :shops, "contents#{i}".to_sym, :string
    end
  end
end
