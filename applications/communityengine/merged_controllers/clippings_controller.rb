class ClippingsController < BaseController
  before_action :login_required, :only => [:new, :edit, :update, :create, :destroy, :new_clipping]
  before_action :find_user, :only => [:new, :edit, :index, :show]
  before_action :require_current_user, :only => [:new, :edit, :update, :destroy]

  uses_tiny_mce do
    {:only => [:show,:new_clipping], :options => configatron.default_mce_options}
  end

  cache_sweeper :taggable_sweeper, :only => [:create, :update, :destroy]

  def site_index
    @clippings = Clipping.includes(:tags).order(params[:recent] ? "created_at DESC" : "clippings.favorited_count DESC")

    @clippings = @clippings.where('tags.name = ?', params[:tag_name]).references(:tags) if params[:tag_name]
    @clippings = @clippings.where('created_at > ?', 4.weeks.ago) unless params[:recent]

    @clippings = @clippings.page(params[:page])

    @rss_title = "#{configatron.community_name}: #{params[:popular] ? :popular.l : :recent.l} "+:clippings.l
    @rss_url = rss_site_clippings_path
    respond_to do |format|
      format.html
      format.rss {
        render_rss_feed_for(@clippings,
           { :feed => {:title => @rss_title, :link => url_for(:controller => 'clippings', :action => 'site_index') },
             :item => {:title => :title_for_rss,
                       :description => Proc.new {|clip| description_for_rss(clip)},
                       :link => Proc.new {|clip| user_clipping_url(clip.user, clip)},
                       :pub_date => :created_at} })

      }
    end

 @section = 'clippings' 
 box do  
 params[:recent] ? :recent.l : :popular.l 
 @clippings.each do |clipping| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 



end

 
 end 
 if @clippings.total_count > 1 
 paginate @clippings, :theme => 'bootstrap' 
 end 
 end 
 widget do  
 :clippings_let_you_to_save_cool_images_from_around_the_web.l 
 if logged_in? 
 link_to :go_to_your_clippings_page_to_get_started.l, user_clippings_path(current_user) 
 else 
 :to_get_started_with_clippings_first.l+" "  
 link_to :create_an_account.l, signup_path 
 end 
 end 
 widget do  
 link_to "#{:view.l} #{params[:recent] ? :popular.l : :recent.l} #{:clippings.l}", site_clippings_path(:recent => params[:recent] ? nil : 'true') 
 end 

  end

  # GET /clippings
  # GET /clippings.xml
  def index
    @user = User.find(params[:user_id])

    @clippings = Clipping.includes(:tags).where(:user_id => @user.id).order("clippings.created_at DESC")

    @clippings = @clippings.where('tags.name = ?', params[:tag_name]) if params[:tag_name]

    @clippings = @clippings.page(params[:page])

    @tags = Clipping.includes(:taggings).where(:user_id => @user.id).tag_counts(:limit => 20)

    @clippings_data = @clippings.collect {|c| [c.id, c.image_url, c.description, c.url ]  }

    @rss_title = "#{configatron.community_name}: #{@user.login}'s clippings"
    @rss_url = user_clippings_path(@user,:format => :rss)

    respond_to do |format|
      format.html # index.rhtml
      format.js { render :inline => @clippings_data.to_json }
      # format.widget { render :template => 'clippings/widget', :layout => false }
      format.rss {
        render_rss_feed_for(@clippings,
           { :feed => {:title => @rss_title, :link => url_for(:controller => 'clippings', :action => 'index', :user_id => @user) },
             :item => {:title => :title_for_rss,
                       :description => Proc.new {|clip| description_for_rss(clip)},
                       :link => :url,
                       :pub_date => :created_at} })

      }
    end
  end

  # GET /clippings/1
  # GET /clippings/1.xml
  def show
    @user = User.find(params[:user_id])
    @clipping = Clipping.find(params[:id])
    @previous = @clipping.previous_clipping
    @next = @clipping.next_clipping

    @related = Clipping.find_related_to(@clipping)

    respond_to do |format|
      format.html # show.rhtml
    end
 @section = 'my_clippings' 
 @meta = { :description => "#{@clipping.description}.",:keywords => "#{@clipping.tags.join(', ') if @clipping.tags}"} 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

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


end

 
 if @previous || @next 
 widget do 
 link_to "<img src='#{@previous.image_uri(:thumb)}' /><br />&laquo; #{:previous.l} ".html_safe, user_clipping_path(@user, @previous), :class => 'pull-left' if @previous 
 link_to "<img src='#{@next.image_uri(:thumb)}' /><br />#{:next.l} &raquo;".html_safe, user_clipping_path(@user, @next), :class => 'pull-right' if @next 
 end 
 end 
 if @related.any? 
 widget do 
 :related_clippings_all_members.l 
 @related.each do |clipping| 
 link_to image_tag(clipping.image_uri(:thumb), :class => "related_clipping polaroid", :alt => clipping.description), user_clipping_url(clipping.user, clipping) 
 end 
 end 
 end 
 if @is_current_user 
 link_to :back.l, user_clippings_path(@user), :class => 'btn btn-default' 
 link_to :edit.l, edit_user_clipping_path(@user, @clipping), :class => 'btn btn-warning' 
 link_to :delete.l, user_clipping_path(@user, @clipping), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 link_to image_tag(@clipping.image_uri(:large), :alt=> @clipping.description, :class => 'thumbnail'), @clipping.url 
 unless @clipping.url.blank? 
 :from.l 
 h @clipping.url  
 h @clipping.description  
 h truncate(@clipping.url, :length => 95) 
 end 
 unless @clipping.description.blank? 
 :description.l 
 h @clipping.description 
 end 
 if @clipping.tags.any? 
 :tags.l 
 @clipping.tags.each do |t| 
 tag_url(t) 
 fa_icon "tag inverse", :text => t.name 
 end 
 end 
 :clipping_comments.l 
 :add_your_comment.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

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


end

 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

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


end

 
 more_comments_links(@clipping) 

  end

  def load_images_from_uri
    uri = URI.parse(params[:uri])
    begin
      doc = Hpricot( open( uri ) )
    rescue
      return
    end
    @page_title = (doc/"title")
    # get the images
    @images = []
    (doc/"img").each do |img|
      begin
        if URI.parse(URI.escape(img['src'])).scheme.nil?
          img_uri = "#{uri.scheme}://#{uri.host}/#{img['src']}"
        else
          img_uri = img['src']
        end
        @images << img_uri
      rescue
        nil
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def new_clipping
    @user = current_user
    @clipping = @user.clippings.new({:url => params[:uri], :description => params[:selection]})
    @post = @user.posts.new_from_bookmarklet(params)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 csrf_meta_tag   
 configatron.community_name 
 :new_clipping.l 
 javascript_include_tag 'community_engine' 
 stylesheet_link_tag 'application' 
 stylesheet_link_tag 'layout' 
 :create_a_clipping.l 
 :click_on_an_image_below_to_clip_it.l 
 image_tag 'spinner.gif', :plugin => "community_engine" 
 :loading_images.l 
 "$('#clipping_image_list').html($.post('#{load_images_from_uri_path(:uri => params[:uri]).html_safe}'));" 
 link_to :cancel_and_go_back_to.l + ' ' + @clipping.url, params[:uri], :class => 'btn btn-xs btn-primary' 
 bootstrap_form_for(:clipping, :url => user_clippings_path(@user), :layout => :horizontal) do |f| 
 f.text_field :url 
 nil 
 f.text_field :image_url 
 f.text_field :tag_list, {:help => :optional_keywords_describing_this_clipping_separated_by_commas.l, :autocomplete => "off",:id => 'clipping_tag_list'} 
 tag_auto_complete_field 'clipping_tag_list', {:url => {:controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 
 f.text_field :description 
 f.primary :create.l 
 end 


end


  end

  # GET /clippings/new
  def new
    @user = User.find(params[:user_id])
    @clipping = @user.clippings.new
 @page_title= :new_clipping.l 
 widget do  
 :help.l 
 :clippings_are_a_way_to_save_images_you_like_from_around_the_web.l 
 end 
 link_to :back.l, user_clippings_path(@user), :class => 'btn btn-default' 
 if @clipping.image_uri 
 image_tag @clipping.image_uri(:large), :class => 'thumbnail' 
 end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @clipping.new_record? 
 url = user_clippings_path(@user) 
 object =  @clipping 
 else 
 url = user_clipping_path(@user, @clipping) 
 object = [@user, @clipping] 
 end 
 bootstrap_form_for(object, :url => url, :layout => :horizontal) do |f| 
 f.text_field :url 
 if @clipping.new_record? 
 f.text_field :image_url 
 end 
 f.text_field :description 
 f.text_field :tag_list 
 :optional_keywords_describing_this_clipping_separated_by_commas.l 
 f.primary :save.l 
 end 


end

 

  end

  # GET /clippings/1;edit
  def edit
    @clipping = Clipping.find(params[:id])
    @user = User.find(params[:user_id])
 @page_title = :editing_clipping.l 
 widget do 
 :help.l 
 :tags_are_keywords_you_use_to_organize_your_clippings_separate_multiple_tags_with_commas.l 
 end 
 link_to :back.l, user_clippings_path(@user), :class => 'btn btn-default' 
 link_to :show.l, user_clipping_path(@user, @clipping), :class => 'btn btn-primary' 
 link_to :delete.l, user_clipping_path(@user, @clipping), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 image_tag @clipping.image_uri(:large), :class => 'thumbnail' 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @clipping.new_record? 
 url = user_clippings_path(@user) 
 object =  @clipping 
 else 
 url = user_clipping_path(@user, @clipping) 
 object = [@user, @clipping] 
 end 
 bootstrap_form_for(object, :url => url, :layout => :horizontal) do |f| 
 f.text_field :url 
 if @clipping.new_record? 
 f.text_field :image_url 
 end 
 f.text_field :description 
 f.text_field :tag_list 
 :optional_keywords_describing_this_clipping_separated_by_commas.l 
 f.primary :save.l 
 end 


end

 

  end

  # POST /clippings
  # POST /clippings.xml
  def create
    @user = current_user
    @clipping = @user.clippings.new(clipping_params)
    @clipping.user = @user
    @clipping.tag_list = params[:tag_list] || ''

    respond_to do |format|
      if @clipping.save!
        flash[:notice] = :clipping_was_successfully_created.l
        format.html {
          unless params[:user_id]
            redirect_to @clipping.url rescue redirect_to user_clipping_url(@user, @clipping)
          else
            redirect_to user_clipping_url(@user, @clipping)
          end
        }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title= :new_clipping.l 
 widget do  
 :help.l 
 :clippings_are_a_way_to_save_images_you_like_from_around_the_web.l 
 end 
 link_to :back.l, user_clippings_path(@user), :class => 'btn btn-default' 
 if @clipping.image_uri 
 image_tag @clipping.image_uri(:large), :class => 'thumbnail' 
 end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @clipping.new_record? 
 url = user_clippings_path(@user) 
 object =  @clipping 
 else 
 url = user_clipping_path(@user, @clipping) 
 object = [@user, @clipping] 
 end 
 bootstrap_form_for(object, :url => url, :layout => :horizontal) do |f| 
 f.text_field :url 
 if @clipping.new_record? 
 f.text_field :image_url 
 end 
 f.text_field :description 
 f.text_field :tag_list 
 :optional_keywords_describing_this_clipping_separated_by_commas.l 
 f.primary :save.l 
 end 


end

 


end

 }
      end
    end
  end

  # patch /clippings/1
  # patch /clippings/1.xml
  def update
    @user = User.find(params[:user_id])
    @clipping = Clipping.find(params[:id])
    @clipping.tag_list = params[:tag_list] || ''

    if @clipping.update_attributes(clipping_params)
      respond_to do |format|
        format.html { redirect_to user_clipping_url(@user, @clipping) }
      end
    else
      respond_to do |format|
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title = :editing_clipping.l 
 widget do 
 :help.l 
 :tags_are_keywords_you_use_to_organize_your_clippings_separate_multiple_tags_with_commas.l 
 end 
 link_to :back.l, user_clippings_path(@user), :class => 'btn btn-default' 
 link_to :show.l, user_clipping_path(@user, @clipping), :class => 'btn btn-primary' 
 link_to :delete.l, user_clipping_path(@user, @clipping), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 image_tag @clipping.image_uri(:large), :class => 'thumbnail' 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 if @clipping.new_record? 
 url = user_clippings_path(@user) 
 object =  @clipping 
 else 
 url = user_clipping_path(@user, @clipping) 
 object = [@user, @clipping] 
 end 
 bootstrap_form_for(object, :url => url, :layout => :horizontal) do |f| 
 f.text_field :url 
 if @clipping.new_record? 
 f.text_field :image_url 
 end 
 f.text_field :description 
 f.text_field :tag_list 
 :optional_keywords_describing_this_clipping_separated_by_commas.l 
 f.primary :save.l 
 end 


end

 


end

 }
      end
    end
  end

  # DELETE /clippings/1
  # DELETE /clippings/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @clipping = Clipping.find(params[:id])
    @clipping.destroy

    respond_to do |format|
      format.html { redirect_to user_clippings_url(@user)   }
    end
  end

  protected

  def description_for_rss(clip)
    "<a href='#{user_clipping_url(clip.user, clip)}' title='#{clip.title_for_rss}'><img src='#{clip.image_url}' alt='#{clip.description}' /></a>"
  end

  private

  def clipping_params
    params.require(:clipping).permit(:url, :description, :image_url, :image)
  end
end
