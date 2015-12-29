class PicturesController < ApplicationController

  LoadAndAuthorizeResource::METHOD_TO_ACTION_NAMES.merge!(
    'next' => 'read',
    'prev' => 'read',
  )

  load_and_authorize_parent :group, optional: true, only: :create, children: :albums
  load_and_authorize_parent :album, optional: true
  before_filter :find_or_create_album_by_name, only: :create
  load_and_authorize_resource except: [:index, :new, :create]

  def index
    redirect_to @album
  end

  def show
 @title = @picture.photo_file_name 
 content_for :header do 
 breadcrumbs 
 link_to prev_album_picture_path(@album, @picture) do 
 icon 'fa fa-arrow-circle-o-left' 
 end 
 @title 
 link_to next_album_picture_path(@album, @picture) do 
 icon 'fa fa-arrow-circle-o-right' 
 end 
 end 
 image_tag @picture.photo.url(:large) 
 if @logged_in.can_update?(@picture) 
 link_to @picture.photo.url, class: 'btn bg-gray' do 
 icon 'fa fa-arrows-alt' 
 t('pictures.show_original') 
 end 
 link_to album_picture_path(@album, @picture, cover: true), data: { confirm: t('are_you_sure') }, method: 'put', class: 'btn bg-gray' do 
 icon 'fa fa-square-o' 
 t('pictures.set_as_cover') 
 end 
 link_to album_picture_path(@album, @picture, degrees: -90), data: { confirm: t('are_you_sure') }, method: 'put', class: 'btn bg-gray' do 
 icon 'fa fa-rotate-left' 
 t('pictures.rotate_left') 
 end 
 link_to album_picture_path(@album, @picture, degrees: 90), data: { confirm: t('are_you_sure') }, method: 'put', class: 'btn bg-gray' do 
 icon 'fa fa-rotate-right' 
 t('pictures.rotate_right') 
 end 
 if @logged_in.can_delete?(@picture) 
 link_to album_picture_path(@album, @picture), data: { confirm: t('are_you_sure') }, method: 'delete', class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 end 
 end 
 if Setting.get(:privacy, :allow_picture_comments) 
 t('Comments') 
 render partial: 'comments/comments', locals: {object: @picture, intro: t('pictures.comment_on_this_picture')} 
 end 

  end

  def new
    @albums = @logged_in.albums.order(:name)
    if @albums.count == 0
      flash[:notice] = t('pictures.create_an_album.notice')
      redirect_to new_person_album_path(@logged_in)
    end
 @title = t('pictures.new.heading') 
 form_for Picture.new do |form| 
 t('pictures.new.existing_album.intro') 
 label_tag :album_id 
 select_tag :album_id, options_from_collection_for_select(@albums, :id, :name, params[:album_id]), include_blank: true, class: 'form-control' 
 picture_upload 
 end 
 t('pictures.new.new_album.intro') 
 link_to new_person_album_path(@logged_in), class: 'btn btn-info' do 
 icon 'ion ion-images' 
 t('pictures.new.new_album.button') 
 end 

  end

  def next
    redirect_to [@album, @picture.next]
  end

  def prev
    redirect_to [@album, @picture.prev]
  end

  def create
    @uploader = PictureUploader.new(@album, params, current_user)
    if @uploader.save
      flash[:notice] = t('pictures.saved', success: @uploader.success)
      respond_to do |format|
        format.html { redirect_to @album }
        format.json { render json: { status: 'success', url: album_path(@album) } }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @uploader.errors.values.join('; ')
          render action: "new"
        end
        format.json { render json: { status: 'error', errors: @uploader.errors.values } }
      end
    end
  end

  # rotate / cover selection
  def update
    if params[:degrees]
      @picture.rotate params[:degrees].to_i
      redirect_to [@album, @picture]
    elsif params[:cover]
      @album.update_attributes!(cover: @picture)
      redirect_to @album
    end
  end

  def destroy
    @picture.destroy
    redirect_to @album
  end

  private

  def find_or_create_album_by_name
    return if @album
    return unless params[:album].presence
    @album = albums.where(name: params[:album].presence).first_or_create! do |album|
      album.owner ||= current_user
      Authority.enforce(:create, album, current_user)
    end
  end

end
