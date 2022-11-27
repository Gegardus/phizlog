class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      # 'sent_to' and 'sent_by' linking assosiations from friendship.rb 
      # to the columns ‘sent_to_id’ and ‘sent_by_id’ as foreign keys.
      t.references :sent_to, null: false, foreign_key: { to_table: :users }
      t.references :sent_by, null: false, foreign_key: { to_table: :users }
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
