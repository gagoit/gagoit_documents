class UserService < BaseService
  ##
  # Get Friends of a Facebook
  #<FbGraph::User:0x0000000784f998 
  #   @identifier="1000021714562171", 
  #   @endpoint="https://graph.facebook.com/1000021714562171", 
  #   @access_token="CAADbgQ47qL..", 
  #   @raw_attributes={
  #     "name"=>"Name", "id"=>"1000021714562171", 
  #     "access_token"=>"CAADbgQ47qL.."
  #   }, 
  #   @cached_collections={}, 
  #   @name="Linh Trần", @first_name=nil, @middle_name=nil, @last_name=nil, @gender=nil, @locale=nil, 
  #   @languages=[], @link=nil, @username=nil, @third_party_id=nil, @timezone=nil, @verified=nil, 
  #   @about=nil, @bio=nil, @education=[], @email=nil, @interested_in=[], @political=nil, @favorite_teams=[], 
  #   @quotes=nil, @relationship_status=nil, @religion=nil, @relationship=nil, @website=nil, @work=[], 
  #   @sports=[], @favorite_athletes=[], @inspirational_people=[], @mobile_phone=nil, @installed=nil, 
  #   @rsvp_status=nil
  # >
  # @author DatPB
  ##
  def self.get_friends_from_facebook(user, need_make_friend = false)
    provider = Provider.by_provider_user("facebook", user.id).first
    return nil if provider.nil?

    begin
      contacts = provider.social_friends
      if contacts.blank?
        contacts = []
        fb_friends = FbGraph::User.me(provider.access_token).fetch.friends
        contacts = fb_friends.map { |e| 
          contact = {
            name: e.name,
            image_url: "https://graph.facebook.com/#{e.identifier}/picture",
            email: '',
            uid: e.identifier
          }

          provider.social_friends.create(contact)
        }

        make_friend_with_social_friends_in_supirb(user, "facebook", contacts.map { |e| e.uid }) if need_make_friend
      end
      
      contacts
    rescue Exception => e
      if e.message.index("401")
        provider.destroy
        nil
      else
        []
      end
    end
    
  end

  ##
  # Get Friends of a Twitter
  ##
  #[<Twitter::User:0x00000004dc01c8 
  # @attrs={:id=>943471222, :id_str=>"943471222", :name=>"Name", :screen_name=>"screen_name", 
  #     :location=>"", :description=>"", :url=>"http://t.co/vnKodNEczk", 
  #     :id=>443709441771192120, :id_str=>"443709441771192120", 
  # :profile_image_url=>"http://pbs.twimg.com/profile_images/443709771397357568/IDoCqNZw_normal.jpeg", 
  # :profile_image_url_https=>"https://pbs.twimg.com/profile_images/443709771397357568/IDoCqNZw_normal.jpeg"
  # }>]
  def self.get_friends_from_twitter(user, need_make_friend = false)
    provider = Provider.by_provider_user("twitter", user.id).first
    return nil if provider.nil?

    begin
      contacts = provider.social_friends
      if contacts.blank?
        contacts = []
        twitter_user = Twitter::Client.new(
          :oauth_token => provider.access_token,
          :oauth_token_secret => provider.secret
        )

        twitter_friends = twitter_user.followers.to_a

        contacts = twitter_friends.map { |e| 
          contact = {
            name: e.name,
            image_url: e.profile_image_url,
            email: '',
            uid: e.id
          }

          provider.social_friends.create(contact)
        }

        make_friend_with_social_friends_in_supirb(user, "twitter", contacts.map { |e| e.uid }) if need_make_friend
      end

      contacts
    rescue Exception => e
      puts e
      if e.message.index("401")
        provider.destroy
        nil
      else
        []
      end
    end
  end

  ##
  # Get Friends of a google
  ##
  def self.get_friends_from_google(user, need_make_friend = false)
    provider = Provider.by_provider_user("google", user.id).first
    return nil if provider.nil?

    url_path = "client_id=#{OMNIAUTH_PROVIDERS['google_oauth2'][:api_id]}&access_token=#{provider.access_token}"
    
    url = "https://www.google.com/m8/feeds/contacts/default/full?#{url_path}&max-results=3000"

    contacts = provider.social_friends #keeps track of all the contacts
    begin
      if contacts.blank?
        contacts = []
        doc = Nokogiri::HTML(open(url))
        doc.css('entry').each do |item|
          #get external id
          base_uri = item.xpath('./id')[0].children.inner_text
          external_id = base_uri.split("base/")[1]

          #get contact name
          name = item.xpath('./title')[0].children.inner_text

          #get contact email addresses
          email_addresses = []

          item.xpath('./email').each do |email|
            email_addresses << email.attributes['address'].inner_text
          end

          #get contact image
          image_url = "https://www.google.com/m8/feeds/photos/media/default/#{external_id}?#{url_path}"

          #create a new contact - see below code for the Contact object
          contact = {
            uid: external_id,
            name: name,
            email: email_addresses.first,
            image_url: image_url
          }
          contacts << provider.social_friends.create(contact)
        end

        make_friend_with_social_friends_in_supirb(user, "google", contacts.map { |e| e.uid }) if need_make_friend
      end
    rescue Exception => e
      if e.message == "401 Token invalid - Invalid token: Token not found"
        provider.destroy if need_make_friend
        contacts = nil
      end
    end
    
    contacts
  end

  ##
  # Get Friends of a linkedin
  #<LinkedIn::Mash 
    # api_standard_profile_request=#<LinkedIn::Mash 
    #   url="http://api.linkedin.com/v1/people/PZt4RtHI3h"
    # > 
    # first_name="minh" 
    # headline="Inspired PHP Engineer at YouNet Company" 
    # id="PZt4RtHI3h" 
    # industry="Information Technology and Services" 
    # last_name="anh" 
    # location=#<LinkedIn::Mash 
    #   country=#<LinkedIn::Mash code="vn"> 
    #   name="Vietnam"
    # > 
    # picture_url="http://m.c.lnkd.licdn.com/mpr/mprx/0_5P24iohpwJYRrI94FqmIieF1IMuRKe94bA4bie3aqsZI723ZdvpqSHvhLA2X17cqkKa62fxsq6-P" 
    # site_standard_profile_request=#<LinkedIn::Mash 
    #   url="http://www.linkedin.com/profile/view?id=126161790&authType=name&authToken=qNGe&trk=api*a3712521*s3783021*"
    # >
  # >
  ##
  def self.get_friends_from_linkedin(user, need_make_friend = false)
    provider = Provider.by_provider_user("linkedin", user.id).first
    return nil if provider.nil?

    linked_in = LinkedIn::Client.new

    linked_in.authorize_from_access(provider.access_token, provider.secret)
    begin
      contacts = provider.social_friends
      if contacts.blank?
        contacts = []
        connections = linked_in.profile.connections
        contacts = connections.all.map { |e|
          contact = {
            name: e.first_name + ' ' + e.last_name,
            image_url: e.picture_url,
            email: '',
            uid: e.id
          }

          provider.social_friends.create(contact)
        }

        make_friend_with_social_friends_in_supirb(user, "linkedin", contacts.map { |e| e.uid }) if need_make_friend
      end

      contacts
    rescue Exception => e
      if e.message.to_s.index("(401): [unauthorized]")
        provider.destroy
        nil
      else
        []
      end
    end
  end

  ##
  # When get friends from a social network(SN), 
  # we will check if friend is sign-up and connect with this SN in Supirb or not:
  #    if yes: make friend with him/her
  #       no: do nothing
  # @param {Array} friend_uids: []
  # @param {provider} : facebook/twitter/linkedin/google..
  ##
  def self.make_friend_with_social_friends_in_supirb(user, provider, friend_uids = [])
    providers = Provider.includes(:user).where(:provider => provider, :uid.in => friend_uids)
    providers.each do |pro|
      p_friend = pro.user
      user.befriend(p_friend) unless p_friend.nil?
    end
  end

  ##
  # Send invitations to social network friends (twitter/linkedin)
  # @param {User} current_user
  # @param {Array} friend_uids: []
  # @param {String} provider: facebook/twitter/linkedin..
  # @param {String} message: "Message .. " (must not inlcude external link when send to twitter)
  # @param {String} subject: "Subject .. "
  #
  # @todo: currently Facebook is not work properly
  # => must be updated
  ##
  def self.send_social_network_invitations(current_user, provider, friend_uids, subject, message)
    begin
      case provider
      when "linkedin"
        if provider = Provider.by_provider_user("linkedin", current_user.id).first

          linked_in = LinkedIn::Client.new

          linked_in.authorize_from_access(provider.access_token, provider.secret)
          response = linked_in.send_message(subject, message + " http://www.masterkc.com/buzz", friend_uids)
        end

      when "twitter"
        if provider = Provider.by_provider_user("twitter", current_user.id).first
          twitter_user = Twitter::Client.new(
            :oauth_token => provider.access_token,
            :oauth_token_secret => provider.secret
          )
          friend_uids.each do |uid|
            Twitter.configure do |config|
              config.consumer_key = OMNIAUTH_PROVIDERS["twitter"][:app_id]
              config.consumer_secret = OMNIAUTH_PROVIDERS["twitter"][:app_secret]
              config.oauth_token = provider.access_token
              config.oauth_token_secret = provider.secret
            end
            twitter_u = twitter_user.user(uid.to_i)
            response = Twitter.direct_message_create(twitter_u, message)
          end
        end

      when "facebook"
        if provider = Provider.by_provider_user("facebook", current_user.id).first
          app_request = FbGraph::User.me(provider.access_token).app_requests({
            :message => message,
            :to      => friend_uids.map { |e| e.to_i  }
          })
        end
      else
        
      end
    rescue Exception => e
      puts e
    end
  end
end