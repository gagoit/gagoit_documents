class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongo

  # for paiging
  extend WillPaginate::PerPage

  attr_accessible :body, :created_by

  field :body, type: String

  searchable do
    text :body
  end
  
  belongs_to :post

  belongs_to :created_by, :class_name => 'User'

  validates :body , :presence => true

  def created!(user)
  	self.created_by = user
  	self.save!
  end

end
