class User
  include Mongoid::Document
  include Mongoid::Paperclip
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :name, :type => String
  field :about_me, :type => String

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :about_me, 
      :avatar, :avatar_cache

  validates :name, :email, :presence => true, :uniqueness => {:case_sensitive => false}

  has_mongoid_attached_file :avatar,
    :path => 'public/system/users/:id/:hash-:style.:extension',
    :default_url => 'users/:no-avatar.jpg',
    
    :hash_secret => GagoitDocuments::Application.config.paperclip_token,

    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['70x70#',   :jpg]
    }
  #mount_uploader :avatar, AvatarUploader

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
end
