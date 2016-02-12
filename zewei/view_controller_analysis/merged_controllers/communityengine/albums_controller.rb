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
 @page_title = @album.title 
  widget do 
 :author.l 
 link_to tag(:img, :src => user.avatar_photo_url(:medium), "alt"=>"#{user.login}", :class => "img-responsive"), user_path(user), :title => "#{user.login}'s"+ :profile.l 
 link_to user.login, user_path(user), :class => 'url' 
 if user.featured_writer?       
 :featured_writer.l 
 end 
 if user.description 
 truncate_words( user.description, 12, '...') 
 end 
 :member_since.l+" #{I18n.l(user.created_at, :format => :short_published_date)}" 
 if user.posts.count == 1 
 link_to :singular_posts.l(:count => user.posts.count), user_posts_path(user) 
 else 
 link_to :plural_posts.l(:count => user.posts.count), user_posts_path(user) 
 end 
 link_to fa_icon('rss', :text => :rss_feed.l), user_posts_path(user, :format => :rss) 
 end 
 
 if @album.user == current_user 
 link_to :back.l, user_photo_manager_index_path(@album.user), :class => 'btn btn-default' 
 link_to :edit.l, edit_user_album_path(@album.user,@album), :class => 'btn btn-warning' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(@album.user,@album), data: { confirm: :delete_album_and_photos.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 h @album.description 
 :photos_of_this_album.l 
 @album_photos.each do |photo| 
 link_to image_tag(photo.photo.url(:thumb)), user_photo_path(photo.user, photo), :class => 'thumbnail' 
 end 
 paginate @album_photos, :theme => 'bootstrap' 
 box :id => 'comments' do 
 :album_comments.l 
 :add_your_comment.l 
  if logged_in? || configatron.allow_anonymous_commenting 
 bootstrap_form_for(:comment, :url => commentable_comments_path(commentable.class.to_s.tableize, commentable), :remote => true, :layout => :horizontal, :html => {:id => 'comment'}) do |f| 
 f.text_area :comment, :rows => 5, :style => 'width: 99%', :class => "rich_text_editor", :help => :comment_character_limit.l 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.form_group do 
 f.check_box :notify_by_email, :label => :notify_me_of_follow_ups_via_email.l 
 if commentable.respond_to?(:send_comment_notifications?) && !commentable.send_comment_notifications? 
 :comment_notifications_off.l 
 end 
 end 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :add_comment.l, data: { disable_with: "Please wait..." } 
 end 
 end 
 else 
 link_to :log_in_to_leave_a_comment.l, new_commentable_comment_path(commentable.class, commentable.id), :class => 'btn btn-primary' 
 link_to :create_an_account.l, signup_path, :class => 'btn btn-primary' 
 end 
 
  comment.id 
 if comment.pending? 
 end 
 if comment.user 
 link_to image_tag(comment.user.avatar_photo_url(:medium), :alt => comment.user.login, :class => "img-responsive"), user_path(comment.user), :rel => 'bookmark', :title => :users_profile.l(:user => comment.user.login), :class => 'list-group-item' 
 user_path(comment.user) 
 fa_icon "hand-o-right fw", :text => comment.user.login 
 commentable_url(comment) 
 fa_icon "calendar" 
 comment.created_at 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? || current_user.moderator?) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 else 
 image_tag(configatron.photo.missing_thumb, :height => '50', :width => '50', :class => "img-responsive") 
 if comment.author_url.blank? 
 h comment.username 
 else 
 link_to fa_icon('hand-o-right', :text => h(comment.username)), h(comment.author_url) 
 end 
 commentable_url(comment) 
 fa_icon "calendar fw" 
 comment.created_at 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? || current_user.moderator?) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 end 
 
 more_comments_links(@album) 
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
 @page_title= :new_album.l 
 widget do  
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 'Album Details' 
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
        format.html {  @page_title= :new_album.l 
 widget do  
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 'Album Details' 
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
        format.html {  @page_title = :edit_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 link_to :show.l, user_album_path(current_user, @album), :class => 'btn btn-primary' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(current_user, @album), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 "Album Details" 
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
