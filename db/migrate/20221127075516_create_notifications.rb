class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|     
      t.integer :notice_id
      t.string :notice_type
      t.boolean :seen, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
