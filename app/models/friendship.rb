class FriendShip
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :inviter, :class_name => 'User', index: true
  belongs_to :invitee, :class_name => 'User', index: true

  field :complete, :type => Boolean, :default => false

  scope :completed, lambda { where(complete: true) }

  scope :not_completed, lambda { where(complete: false) }
end
