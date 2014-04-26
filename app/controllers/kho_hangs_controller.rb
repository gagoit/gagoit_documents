class KhoHangsController < ApplicationController
  def index

  end

  def get_vi_tris
    @vitris = KhoHang.all
    
    respond_to do |format|
      format.html {render :layout => false}
      format.json { render json: {vitris: (vitris.map { |e| e.to_json })} }
    end
  end
end
