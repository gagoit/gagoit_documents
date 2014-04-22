class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user

  field :date, :type => Date

  field :description, :type => String

  has_many :photos
end
