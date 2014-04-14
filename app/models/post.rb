class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongo

  # for paiging
  extend WillPaginate::PerPage

  attr_accessible :title, :body, :created_by, :category

  CATEGORIES = {
    "ror" => "Ruby on Rails",
    "html_css" => "HTML & CSS",
    "javascript_jquery" => "Javascript & Jquery",
    "java" => "Java",
    "database" => "Database",
    "others" => "Others"
  }

  field :title, type: String
  field :body, type: String
  field :category, type: String

  searchable do
    text :title
    text :body

    text :comments do
      comments.map { |comment| "#{comment.body}" }
    end
  end

  belongs_to :created_by, :class_name => 'User'
  has_many :comments, :order => [[:created_at, :asc]]

  validates :title, :body , :presence => true
  validates :category, :presence => true, :inclusion => { :in => CATEGORIES.keys }

  scope :by_category, lambda { |category|
    where(:category => category)
  }

  def created!(user)
  	self.created_by = user
  	self.save!
  end
end
