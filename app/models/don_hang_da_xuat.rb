class DonHangDaXuat
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

  field :vi_tri, type: String
  field :so_luong, type: Integer

  field :import_date, type: Date

  belongs_to :user
end
