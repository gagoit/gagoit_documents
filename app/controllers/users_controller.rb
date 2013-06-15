class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :xml, :json
  def show
    @user = current_user
  end

  def edit
  	@user = current_user
  end

  def update
  	@user.update_attributes(params[:user])

  	respond_with @user
  end
end
