class ViTriDonHang
  include Mongoid::Document
  include Mongoid::Timestamps

  field :vi_tri, type: String
  field :so_luong, type: Integer

  belongs_to :don_hangs
  belongs_to :user

  validates :vi_tri_name, length: {maximum: 10}
  validates :qty, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
