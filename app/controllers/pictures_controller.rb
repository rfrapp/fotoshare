class PicturesController < ApplicationController
  before_action :logged_in_user

  def new
    @albums = current_user.albums
    @picture = @albums.first.pictures.build
  end

  def create
    @album = Album.find(params[:album_id])
    @picture = @album.pictures.build(picture_params)
    if @picture.save
      flash[:success] = "Picture uploaded!"
      redirect_to @album
    else
      render @album
    end

  end

  def show
    @picture = Picture.find(params[:id])
  end

  private
  
  def picture_params
    params.require(:picture).permit(:caption, :description, :location)
  end
    
  def destroy
  end
end
