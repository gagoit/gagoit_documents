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

  def get_vi_tri
    @vitri = KhoHang.get_vi_tri(params[:vitri])
    @show_type = params[:show_type]

    respond_to do |format|
      format.html {render :layout => false}
      format.json { render json: @vitri }
    end
  end
end
