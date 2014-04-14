class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
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

  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :linkedin, :google]

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :about_me, 
      :avatar, :avatar_cache

  validates :name, :email, :presence => true, :uniqueness => {:case_sensitive => false}

  has_mongoid_attached_file :avatar,
    :path => 'users/avatars/:id/:style.:extension',
    :default_url => 'no-avatar.jpg',
    
    :hash_secret => GagoitDocuments::Application.config.paperclip_token,

    :styles => {
      :original => ['1920x1680>', :jpg],
      :medium   => ['250x250',    :jpg],
      :small    => ['70x70#',   :jpg]
    }

  validates_attachment_content_type :avatar, :content_type => %w[image/png image/jpg image/jpeg image/gif]

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  field :remember_me, :type => Boolean

  has_many :providers, dependent: :delete

  has_many :posts
  has_many :comments

  ##
  # Dynamically create find_for_facebook_oauth and find_for_twitter_oauth methods
  [:facebook, :twitter, :linkedin, :google].each do |mode|
    class_eval <<-RUBY_EVAL
      def self.find_for_#{mode}_oauth(omniauth_param, current_user=nil)
        data = JSON.parse(omniauth_param.to_json)

        if current_user # Inviter Friends || Connect
          pro = Provider.find_or_create(data, current_user)

          current_user
        else
          user_fb = {
            email: data['info']['email'],
            first_name: data['info']['first_name'],
            last_name: data['info']['last_name'],
            short_name: data['info']['nickname'] || "wb#{Devise.friendly_token[0,8]}"
          }

          if user_fb[:email].blank?
            return nil
          elsif user = User.where(:email => user_fb[:email]).first
            user.update_attributes(user_fb)

          else # Create a user with a stub password. 
            user_fb[:password] = Devise.friendly_token[0,20]
            user = User.create!(user_fb )
          end

          Provider.find_or_create(data, user)

          user
        end
      end
    RUBY_EVAL
  end
end
