class Provider
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :email, :name, :provider, :provider_user_name, :uid, :url_provider,
    :user_id, :image_url, :access_token, :secret

  field :provider, :type => String            #Provider's name: facebook, twitter, google, linkedin
  field :uid, :type => String
  field :name, :type => String                #name of User in Provider
  field :email, :type => String               #email of User in Provider
  field :provider_user_name, :type => String  #user_name of User in Provider
  field :url_provider, :type => String
  field :image_url, :type => String
  field :access_token, :type => String        #for Twitter
  field :secret, :type => String              #for Twitter


  belongs_to :user

  has_many :social_friends, dependent: :delete

  PROVIDERS = {
    "facebook" => "Facebook",
    "twitter"  => "Twitter",
    "linkedin" => "LinkedIn",
    "google" => "Google"
  }

  scope :by_provider_user, lambda{|provider_name, user_id|
    where(:provider => provider_name, :user_id => user_id)
  }

  ###########################################################
  #  get providers info of a user
  #
  # * *Args*    :
  #   - +user_id+       ->user_id
  # * *Return*  : user providers information
  # Example:
  #data: {
  # "provider1" => provider1,
  # "provider2" => provider2
  #},
  # *Written:* DatPB
  #
  # *Date:*    
  #
  # *Modified:*
  #
  # *Date:*
  #
  def self.get_user_providers_info(user_id)
    user_providers = self.where(:user_id => user_id)
    user_providers_hash = {}

    user_providers.each do |u_p|
      user_providers_hash[u_p.provider] = u_p
    end

    user_providers_hash
  end

  ##
  # Base on omniauth data and user, find an create provider (facebook/twitter/linkedin)
  # @author DatPB
  ##
  def self.find_or_create(omniauth_data, current_user)
    
    provider_name = omniauth_data['provider']
    u_name = if provider_name == 'facebook' || provider_name == 'linkedin'
        omniauth_data['info']['first_name'] + ' ' + omniauth_data['info']['last_name']
      else
        nil
      end

    p_url = if provider_name == 'facebook' || provider_name == 'twitter'
        omniauth_data['info']['urls'][PROVIDERS[provider_name]]
      elsif provider_name == 'linkedin'
        omniauth_data['info']['urls']['public_profile']
      else
        ''
      end

    p_uid = omniauth_data["uid"]
    
    p_uid = get_linkedin_uid(omniauth_data) if provider_name == "linkedin"

    if pro = Provider.by_provider_user(provider_name, current_user.id).first
      pro
    else
      p_hash = {
        email: omniauth_data['info']['email'] || '', 
        name: u_name, 
        provider: provider_name, 
        provider_user_name: omniauth_data['info']['nickname'], 
        uid: p_uid, 
        url_provider: p_url,
        user_id: current_user.id, 
        image_url: omniauth_data['info']['image'], 
        access_token: omniauth_data['credentials']['token'],
        secret: omniauth_data['credentials']['secret']
      }

      pro = Provider.create!(p_hash)
      UserService.delay.send("get_friends_from_#{provider_name}", current_user, true)
    end

    pro
  end

  def self.get_linkedin_uid(omniauth_data)
    linked_in = LinkedIn::Client.new
    rtoken = omniauth_data['credentials']['token']
    rsecret = omniauth_data['credentials']['secret']

    linked_in.authorize_from_access(rtoken, rsecret)
    begin
      linked_in.profile.id
    rescue Exception => e
      ""
    end
  end
end
