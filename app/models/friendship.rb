class Friendship < ApplicationRecord
  # associative links create two associations between Friendships and User
  # the columns ‘sent_to_id’ and ‘sent_by_id’ as foreign keys are linked 
  # with 'sent_to' and 'sent_by' due to assosiations 
  belongs_to :sent_to, class_name: 'User', foreign_key: 'sent_to_id'
  belongs_to :sent_by, class_name: 'User', foreign_key: 'sent_by_id'
  scope :friends, -> { where('status =?', true) }
  scope :not_friends, -> { where('status =?', false) }
end
