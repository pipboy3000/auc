class CreateHtmlTempaltes < ActiveRecord::Migration
  def up
    create_table :html_templates do |t|
      t.string :name, null:false
      t.text :contents, null:false
      t.timestamps
    end
  end

  def down
    drop_table :html_templates
  end
end
