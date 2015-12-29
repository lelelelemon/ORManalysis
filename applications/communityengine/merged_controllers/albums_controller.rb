class AlbumsController < BaseController
  include Viewable
  before_action :login_required, :except => [:show]
  before_action :find_user, :only => [:new, :edit, :index]
  before_action :require_current_user, :only => [:new, :edit, :update, :destroy, :create]

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end


  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])
    update_view_count(@album) if current_user && current_user.id != @album.user_id
    @album_photos = @album.photos.page(params[:page]).per(10)
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end
  


  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
 @page_title = :edit_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 link_to :show.l, user_album_path(current_user, @album), :class => 'btn btn-primary' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(current_user, @album), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 "Album Details" 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
 end 


end

 

  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(album_params)
    @album.user_id = current_user.id
    
    respond_to do |format|
      if @album.save
        if params[:go_to] == 'only_create'
          flash[:notice] = :album_was_successfully_created.l 
          format.html { redirect_to(user_photo_manager_index_path(current_user)) }       
        else
          format.html { redirect_to(new_user_album_photo_path(current_user, @album)) }
        end
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title= :new_album.l 
 widget do  
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 'Album Details' 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
 end 


end

 


end

 }
      end 
    end
  end

  # patch /albums/1
  # patch /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(album_params)
        if params[:go_to] == 'only_create'
          flash[:notice] = :album_updated.l
          format.html { redirect_to(user_album_path(current_user, @album)) }
        else
          format.html { redirect_to(new_user_album_photo_path(current_user, @album)) }
        end
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title = :edit_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 link_to :show.l, user_album_path(current_user, @album), :class => 'btn btn-primary' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(current_user, @album), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 "Album Details" 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
 end 


end

 


end

 }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy  
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to user_photo_manager_index_path(current_user) }
      format.xml  { head :ok }
    end
  end
  
  def add_photos
    @album = Album.find(params[:id])
  end
  
  def photos_added
    @album = Album.find(params[:id])
    @album.photo_ids = params[:album][:photos_ids].uniq
    redirect_to user_albums_path(current_user)
    flash[:notice] = :album_added_photos.l
  end

  private

  def album_params
    params[:album].permit(:title, :description)
  end
  
end
