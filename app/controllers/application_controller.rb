class ApplicationController < ActionController::Base
  #before_filter :authenticate_user!, :except => [:show, :index]
  protect_from_forgery
  layout "new_layout"
end
