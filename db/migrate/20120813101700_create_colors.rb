class CreateColors < ActiveRecord::Migration
  def up
    create_table :colors do |t|
      t.string :name, null:false
      t.string :title, null:false
      t.string :frame, null:false
      t.string :text1, null:false
      t.string :text2, null:false
      t.string :bg1, null:false
      t.string :bg2, null:false
      t.timestamps
    end
  end

  def down
    drop_table :colors
  end
end
