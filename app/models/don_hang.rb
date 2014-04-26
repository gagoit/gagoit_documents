class DonHang
  include Mongoid::Document
  include Mongoid::Timestamps

  field :mo, type: String
  field :batch, type: String
  field :color, type: String
  field :return_date, type: Date

  field :qty, type: Float
  field :unit, type: String
  field :size, type: String
  field :remark, type: String

  has_many :vi_tri_don_hangs, inverse_of: :vi_tris

  validates :mo, :batch, :color, :return_date, :size, :qty, :unit, :remark, :presence => true

  validates :qty, numericality: { greater_than_or_equal_to: 0.0, only_integer: false }

  validates :mo, :batch, :color, length: {maximum: 100}
  validates :remark, length: {maximum: 1000}
end
