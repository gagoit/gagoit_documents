class SocialFriend
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :provider

  field :uid, :type => String
  field :name, :type => String
  field :image_url, :type => String
  field :email, :type => String
  field :provider_name, :type => String

  def to_json
    {
      name: name,
      image_url: (image_url || ''),
      email: (email || ''),
      uid: uid
    }
  end
end
