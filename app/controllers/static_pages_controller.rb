class StaticPagesController < ApplicationController
	skip_filter :authenticate_user!
  def about
  end

  def cat_tuong
  end
end
