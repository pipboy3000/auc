class DeleteReferenceUser < ActiveRecord::Migration
  def up
    remove_column :text_templates, :user_id
  end

  def down
    change_table :text_templates do |t|
      t.references :user
    end
  end
end
