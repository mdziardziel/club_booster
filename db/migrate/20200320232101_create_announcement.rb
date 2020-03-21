class CreateAnnouncement < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.text :content, null: false
      t.integer :members_ids, array: true, default: []
      t.integer :club_id, null: false
      t.references :club, index: true
    end
  end
end
