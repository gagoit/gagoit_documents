class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  ##
  # params = {
  # 	invitee_id: user_id
  # }
  ##
  def create
    @return_data = {success: true, message: "The invitation has been sent successfully."}
    if user = User.find(params[:invitee_id])
      unless current_user.is_friend?(user.id)
        unless current_user.not_completed_friend?(user.id)
          fs = Friendship.create({inviter_id: current_user.id, invitee_id: user.id})
          @return_data = {success: false, message: "Error"} if fs.errors
        end
      end
    else
      @return_data = {success: false, message: "You can not make friend with user is not exists in the application."}
    end

    respond_to do |format|
      format.html
      format.json { render json: return_data }
      format.js { render :layout => false  }
    end
  end
end
