class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  # for paiging
  extend WillPaginate::PerPage

  attr_accessible :title, :body, :created_by

  field :title, type: String
  field :body, type: String

  belongs_to :created_by, :class_name => 'User'
  embeds_many :comments, :order => [[:created_at, :asc]]

  validates :title, :body , :presence => true

  def created!(user)
  	self.created_by = user
  	self.save!
  end
end
