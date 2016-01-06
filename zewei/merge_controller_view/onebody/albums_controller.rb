class AlbumsController < ApplicationController

  load_and_authorize_parent :group, :person, shallow: true
  load_and_authorize_resource

  def index
    @owner = @group || @person
    @albums = albums.readable_by(current_user)
    respond_to do |format|
      format.html
      format.js { render text: @albums.to_json }
    end
  end

  def show
    @pictures = @album.pictures.order(:id).page(params[:page])
 @title = @album.name 
 @album.description 
 pagination @pictures 
 @pictures.each do |picture| 
 link_to image_tag(picture.photo.url(:small), alt: t('pictures.click_to_enlarge'), class: 'picture-small thumbnail'), [@album, picture], title: t('pictures.click_to_enlarge') 
 end 
 if @pictures.empty? 
 t('pictures.none') 
 end 
 pagination @pictures 
 if @logged_in.can_create?(@album.pictures.new) 
 form_for [@album, @album.pictures.new], html: { multipart: true } do 
 picture_upload(@album) 
 end 
 end 
 if @album.cover 
 link_to image_tag(@album.cover.photo.url(:large), alt: t('pictures.click_to_enlarge'), class: 'picture thumbnail'), [@album, @album.cover], title: t('pictures.click_to_enlarge') 
 else 
 image_tag 'picture.large.jpg', class: 'picture thumbnail' 
 end 
 if @logged_in.can_update?(@album) 
 link_to edit_album_path(@album), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 t('albums.edit.button') 
 end 
 if @logged_in.can_delete?(@album) 
 link_to @album, data: { method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('albums.delete.button') 
 end 
 end 
 end 

  end

  def new
 @title = t('.heading') 
 render partial: 'form' 

  end

  def create
    if @album.save
      flash[:notice] = t('albums.saved')
      redirect_to @album
    else
      render action: 'new'
    end
  end

  def edit
 @title = t('.heading') 
 render partial: 'form' 

  end

  def update
    if @album.update_attributes(album_params)
      flash[:notice] = t('Changes_saved')
      redirect_to @album
    else
      render action: 'edit'
    end
  end

  def destroy
    owner = @album.owner
    @album.destroy
    redirect_to [owner, :albums]
  end

  private

  def album_params
    params.require(:album).permit(:name, :description, :is_public)
  end

end
