class Photo
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  
  has_mongoid_attached_file :image, styles: {  large: ["1024", :jpg],
                                                :medium   => ['250x250',    :jpg],
                                                :small    => ['70x70#',   :jpg],
                                                thumb: ["100x100#", :jpg] },
                                  convert_options: {all: ["-unsharp 0.3x0.3+5+0", "-quality 90%", "-auto-orient"]},
                                  processors: [:thumbnail] ,
                                  storage: :filesystem

  validates_attachment_content_type :image, :content_type => %w[image/png image/jpg image/jpeg image/gif]
end
