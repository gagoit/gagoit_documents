class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  skip_before_filter :validated_user
  
  def facebook
    @user = User.find_for_facebook_oauth(omniauth_param, current_user)
    
    if current_user #invite friend from facebook || connectting with facebook
      if session["facebook"][:invite_friends]  #invite friend from facebook
        redirect_to invite_friends_friendships_path(provider: "facebook")
      else
        redirect_to root_path
      end

    else #Login/sign up with facebook
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        
        session['fb_access_token'] = omniauth_param["credentials"]["token"]
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.facebook_data"] = omniauth_param
        redirect_to new_user_registration_url
      end
    end
  end
    
  def twitter
    @user = User.find_for_twitter_oauth(omniauth_param, current_user)
    
    if current_user #invite friend from twitter || connectting with twitter
      if session["twitter"][:invite_friends]  #invite friend from twitter
        redirect_to invite_friends_friendships_path(provider: "twitter")
      else
        redirect_to root_path
      end

    else #Login/sign up with twitter
      if @user && @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.twitter_data"] = omniauth_param
        redirect_to new_user_registration_url
      end
    end
    
  end

  #<OmniAuth::AuthHash 
  #   credentials=#<Hashie::Mash 
  #     expires=true 
  #     expires_at=1396766943 
  #     token="ya29.1.AADtN_XqmKdYjbCNQrXH8jYQZw_DOm49EqLL5sNiGJz5GJJjdky-3E5Hh0r-oLifBQ"
  #   > 
  #   info=#<OmniAuth::AuthHash::InfoHash 
  #     email="vuongtieulong02@gmail.com" 
  #     first_name="Long" 
  #     image="https://lh4.googleusercontent.com/-v9QNmjJ9KyI/AAAAAAAAAAI/AAAAAAAAACo/JcLH_yXwT4M/photo.jpg" 
  #     last_name="Tieu" 
  #     name="Long Tieu" 
  #     urls=#<Hashie::Mash 
  #       Google="https://plus.google.com/114597442723303384812"
  #     >
  #   > 
  #   provider="google" 
  #   uid="114597442723303384812"
  # >
  def google
    
    @user = User.find_for_google_oauth(omniauth_param, current_user)
    
    if current_user #invite friend from google || connectting with google
      if session["google"][:invite_friends]  #invite friend from google
        redirect_to invite_friends_friendships_path(provider: "google")
      else
        redirect_to root_path
      end

    else #Login/sign up with google
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = omniauth_param
        redirect_to new_user_registration_url
      end
    end
  end

  #<OmniAuth::AuthHash 
    # credentials=#<Hashie::Mash 
      # secret="78acecb3-fb5f-4960-8357-949ef416d6e0" 
      # token="a6dab967-e363-4811-9df8-2422e527f028"
    # > 
    # info=#<OmniAuth::AuthHash::InfoHash 
    #   description="Software Engineer at LARION Computing Ltd." 
    #   email="dat_phamba1307@yahoo.com" 
    #   first_name="Dat" 
    #   headline="Software Engineer at LARION Computing Ltd." 
    #   image="http://m.c.lnkd.licdn.com/mpr/mprx/0_jOgiHrvqB7CDTC760xjyHPnUBuvfi3a60JWyHPXke7T0p5JQl4SfQ1KEMXzr86fopjxjFqstyTs-" 
    #   industry="Computer Software" 
    #   last_name="Pham Ba" 
    #   location="Vietnam, VN" 
    #   name="Dat Pham Ba" 
    #   nickname="Dat Pham Ba" 
    #   phone=nil 
    #   urls=#<Hashie::Mash 
    #     public_profile="http://www.linkedin.com/pub/dat-pham-ba/38/332/736"
    #   >

    # > 

    # provider="linkedin" 
    # uid="b3LN8xcAmH"
  # >
  def linkedin
    
    @user = User.find_for_linkedin_oauth(omniauth_param, current_user)
    
    if current_user #invite friend from linkedin || connectting with linkedin
      if session["linkedin"][:invite_friends]  #invite friend from linkedin
        redirect_to invite_friends_friendships_path(provider: "linkedin")
      else
        redirect_to root_path
      end

    else #Login/sign up with linkedin
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "LinkedIn"
      
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.linkedin_data"] = omniauth_param
        redirect_to new_user_registration_url
      end
    end
  end

  ##
  # When authorize failure
  # @author DatPB
  ##
  def failure
    redirect_to root_path
  end

  private

  ##
  # Get omniauth param
  # @author DatPB
  ##
  def omniauth_param
    request.env["omniauth.auth"].except(:extra) || {}
  end
end