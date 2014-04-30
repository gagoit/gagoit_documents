class ViTriDonHang
  include Mongoid::Document
  include Mongoid::Timestamps

  field :so_luong, type: Integer

  belongs_to :don_hangs
  belongs_to :user
  belongs_to :vi_tri

  validates :so_luong, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
