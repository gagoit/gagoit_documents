module UsersHelper
	def avatar_url(user)
		(user && user.avatar) ? user.avatar.url : 'no-avatar.jpg'
	end

  def medium_image_tag(reavatar)
    image_tag_with(reavatar, :medium, :small)
  end
  
  def small_image_tag(reavatar)
    image_tag_with(reavatar, :small, :medium, 80, 80)
  end

  def small_large_image_tag(reavatar)
    image_tag_with(reavatar, :small, :large, 80, 80)
  end
  
  def missing_image_tag(size)
    image_tag("properties/#{size}-missing.gif", :alt => 'No Image Available')
  end
  
  protected
  
  def image_tag_with(reavatar, style, other_style, height = nil, width = nil)
    opts = {
      :alt => "#{style} image",
      :"data-#{other_style}" => reavatar.avatar(other_style) 
    }
    
    opts.merge!( :height => height, :width => width ) unless height.nil? || width.nil?
    
    image_tag(reavatar.avatar(style), opts)
  end
end
