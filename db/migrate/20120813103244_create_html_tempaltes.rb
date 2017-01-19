class CreateHtmlTempaltes < ActiveRecord::Migration[4.2]
  def up
    create_table :html_templates do |t|
      t.string :name, null: false
      t.text :contents, null: false
      t.timestamps null: false
    end
  end

  def down
    drop_table :html_templates
  end
end
