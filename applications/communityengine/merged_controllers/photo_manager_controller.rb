class PhotoManagerController < BaseController
  include Viewable
  before_action :login_required
  before_action :find_user
  before_action :require_current_user
  
  def index
    @albums = current_user.albums.order('id DESC').page(params[:page_albums])
    @photos_no_albums = current_user.photos.where('album_id IS NULL').order('id DESC').page(params[:page])
 @page_title = :photo_manager.l 
 widget do 
 :links.l 
 link_to :view_all_my_photos.l, user_photos_path(current_user) 
 link_to :new_photo.l, new_user_photo_path(current_user) 
 link_to :new_album.l, new_user_album_path(current_user) 
 end 
 :albums.l 
 :title.l 
 :preview.l 
 :created_at.l 
 :actions.l 
 @albums.each do |album| 
 link_to album.title, user_album_path(current_user,album) 
 if album.photos[0] 
 link_to image_tag( album.photos[0].photo.url(:thumb), :size => "50x50"), user_photo_path(current_user, album.photos[0]) 
 end 
 if album.photos[1] 
 link_to image_tag( album.photos[1].photo.url(:thumb), :size => "50x50"), user_photo_path(current_user, album.photos[1]) 
 end 
 if album.photos[2] 
 link_to image_tag( album.photos[2].photo.url(:thumb), :size => "50x50"), user_photo_path(current_user, album.photos[2]) 
 end 
 album.created_at 
 album.created_at.strftime("%Y/%m/%d") 
 link_to :show.l, user_album_path(current_user,album), :class => 'btn btn-default' 
 link_to :edit.l, edit_user_album_path(current_user,album), :class => 'btn btn-warning' 
 link_to :add_photos.l, new_user_album_photo_path(current_user,album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(current_user,album), data: { confirm: :delete_album_and_photos.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 paginate @albums, :theme => 'bootstrap' 
 link_to :new_album.l, new_user_album_path(current_user), :class => 'btn btn-success' 
 :not_assigned_photos.l 
 @photos_no_albums.each do |photo| 
 link_to image_tag( photo.photo.url(:thumb)), user_photo_path(current_user, photo), :class => 'thumbnail' 
 link_to :show.l, user_photo_path(current_user, photo), :class => 'btn btn-xs btn-default' 
 link_to :edit.l, edit_user_photo_path(current_user, photo), :class => 'btn btn-warning btn-xs' 
 link_to :delete.l, edit_user_photo_path(current_user, photo), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger btn-xs' 
 end 
 paginate @photos_no_albums, :theme => 'bootstrap' 
 link_to :new_photo.l, new_user_photo_path(current_user), :class => 'btn btn-success' 

  end
end