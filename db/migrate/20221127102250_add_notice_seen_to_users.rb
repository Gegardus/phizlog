class AddNoticeSeenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notice_seen, :boolean, default: true
  end
end
