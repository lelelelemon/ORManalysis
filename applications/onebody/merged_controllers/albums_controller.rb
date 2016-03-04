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
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = link_to(@owner.name, @owner) + ' ' + t('.heading') 
 if @owner and @logged_in.can_create?(@owner.albums.new) 
 link_to [:new, @owner, :album], class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('albums.new.button') 
 end 
 end 
  if @albums.any? 
 t('albums.table.name') 
 t('albums.table.picture_count') 
 t('albums.table.created_at') 
 if show_album_actions 
 end 
 @albums.each do |album| 
 link_to album do 
 avatar_tag(album, size: :small, class: 'thumbnail') 
 end 
 link_to album.name, album 
 album.pictures.count 
 album.created_at.to_s(:date) 
 if show_album_actions 
 link_to edit_album_path(album), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 end 
 link_to album, data: { method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 end 
 end 
 end 
 else 
 t('albums.none') 
 end 
 

end

  end

  def show
    @pictures = @album.pictures.order(:id).page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @album.name 
 @album.description 
 pagination @pictures 
 @pictures.each do |picture| 
 link_to image_tag(picture.photo.url(:small), alt: t('pictures.click_to_enlarge'), class: 'picture-small thumbnail'),          [@album, picture], title: t('pictures.click_to_enlarge') 
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
 link_to image_tag(@album.cover.photo.url(:large), alt: t('pictures.click_to_enlarge'), class: 'picture thumbnail'),        [@album, @album.cover], title: t('pictures.click_to_enlarge') 
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

  end

  def new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  form_for @group ? [@group, @album] : [@person, @album] do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 unless @album.group and @album.group.private? 
 label_tag t('albums.sharing.heading') 
 form.radio_button :is_public, true 
 form.label :is_public_true, t('albums.is_public.enabled'), class: 'inline' 
 end 
 form.radio_button :is_public, false 
 if @album.group 
 form.label :is_public_false, t('albums.is_public.disabled_group'), class: 'inline' 
 else 
 form.label :is_public_false, t('albums.is_public.disabled_profile', url: stream_people_path).html_safe, class: 'inline' 
 end 
 form.button t('albums.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def create
    if @album.save
      flash[:notice] = t('albums.saved')
      redirect_to @album
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  form_for @group ? [@group, @album] : [@person, @album] do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 unless @album.group and @album.group.private? 
 label_tag t('albums.sharing.heading') 
 form.radio_button :is_public, true 
 form.label :is_public_true, t('albums.is_public.enabled'), class: 'inline' 
 end 
 form.radio_button :is_public, false 
 if @album.group 
 form.label :is_public_false, t('albums.is_public.disabled_group'), class: 'inline' 
 else 
 form.label :is_public_false, t('albums.is_public.disabled_profile', url: stream_people_path).html_safe, class: 'inline' 
 end 
 form.button t('albums.save'), class: 'btn btn-success' 
 end 
 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  form_for @group ? [@group, @album] : [@person, @album] do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 unless @album.group and @album.group.private? 
 label_tag t('albums.sharing.heading') 
 form.radio_button :is_public, true 
 form.label :is_public_true, t('albums.is_public.enabled'), class: 'inline' 
 end 
 form.radio_button :is_public, false 
 if @album.group 
 form.label :is_public_false, t('albums.is_public.disabled_group'), class: 'inline' 
 else 
 form.label :is_public_false, t('albums.is_public.disabled_profile', url: stream_people_path).html_safe, class: 'inline' 
 end 
 form.button t('albums.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def update
    if @album.update_attributes(album_params)
      flash[:notice] = t('Changes_saved')
      redirect_to @album
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  form_for @group ? [@group, @album] : [@person, @album] do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 unless @album.group and @album.group.private? 
 label_tag t('albums.sharing.heading') 
 form.radio_button :is_public, true 
 form.label :is_public_true, t('albums.is_public.enabled'), class: 'inline' 
 end 
 form.radio_button :is_public, false 
 if @album.group 
 form.label :is_public_false, t('albums.is_public.disabled_group'), class: 'inline' 
 else 
 form.label :is_public_false, t('albums.is_public.disabled_profile', url: stream_people_path).html_safe, class: 'inline' 
 end 
 form.button t('albums.save'), class: 'btn btn-success' 
 end 
 

end

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
