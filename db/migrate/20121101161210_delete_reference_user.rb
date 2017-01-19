class DeleteReferenceUser < ActiveRecord::Migration[4.2]
  def up
    remove_column :text_templates, :user_id
  end

  def down
    change_table :text_templates do |t|
      t.references :user
    end
  end
end
