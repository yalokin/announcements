class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.references :announcement, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :price
      t.integer :status

      t.timestamps
    end
  end
end
