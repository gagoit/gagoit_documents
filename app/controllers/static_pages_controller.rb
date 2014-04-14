class StaticPagesController < ApplicationController
	skip_filter :authenticate_user!
  def about
  end
end
