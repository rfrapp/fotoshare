class AlbumsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  def new
    @album = current_user.albums.build
  end

  def create
    @album = current_user.albums.build(album_params)
    if @album.save
      flash[:success] = "Album created!"
      redirect_to albums_path
    else
      render albums_path
    end
  end

  def show
    @album = Album.find(params[:id])
    @pictures = @album.pictures.paginate(page: params[:page])
  end

  def destroy
    @album.destroy
    flash[:success] = "Album deleted"
    redirect_to request.referrer || root_url
  end

  def index
    @albums = current_user.albums.paginate(page: params[:page])
  end
  
  private

  def album_params
    params.require(:album).permit(:title, :description)
  end

  def correct_user
    @album = current_user.albums.find_by(id: params[:id])
    redirect_to root_url if @album.nil?
  end
end
