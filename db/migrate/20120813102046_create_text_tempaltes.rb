class CreateTextTempaltes < ActiveRecord::Migration
  def up
    create_table :text_templates do |t|
      t.string :name, :null => false
      t.text :header
      t.string :col1_title
      t.string :col2_title
      t.string :col3_title
      t.string :col4_title
      t.string :col5_title
      t.text :col1_text
      t.text :col2_text
      t.text :col3_text
      t.text :col4_text
      t.text :col5_text
      t.text :footer

      t.references :user
      t.timestamps null: false
    end
  end

  def down
    drop_table :text_templates
  end
end
