class ApplicationController < ActionController::Base
  #before_filter :authenticate_user!, :except => [:show, :index]
  protect_from_forgery
  layout "new_layout"

  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end
end
