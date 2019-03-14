class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.references :user, foreign_key: true
      t.text :description, limit: 1000
      t.integer :status

      t.timestamps
    end
  end
end
