class FavoritesController < BaseController
  before_action :login_required, :only => [:destroy]
  before_action :find_user, :only => [:show, :index]

  cache_sweeper :favorite_sweeper, :only => [:create, :destroy]

  def create
    @favoritable = params[:favoritable_type].classify.constantize.find(params[:favoritable_id])
    @favorite = Favorite.new(:ip_address => request.remote_ip, :favoritable => @favoritable )
    @favorite.user = current_user || nil
    @favorite.save

    respond_to do |format|
      format.js
    end
 if @favorite.new_record? 
 @favorite.errors.full_messages.join(', ').html_safe 
 else 
 case @favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
  if favorite = clipping.has_been_favorited_by(current_user, request.remote_ip) 
 link_to favorite_path('clipping', clipping.id, favorite.id), :method => :delete, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s if logged_in? do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 :in_your_favorites.l 
 end 
 else 
 link_to favorites_path('clipping', clipping.id), :method => :post, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 end 
 end 
 
 when 'posts' 
 render :partial => 'posts/meta', :locals => {:post => @favorite.favoritable} 
 end 
 end 

  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.js
    end
 case @favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
  if favorite = clipping.has_been_favorited_by(current_user, request.remote_ip) 
 link_to favorite_path('clipping', clipping.id, favorite.id), :method => :delete, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s if logged_in? do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 :in_your_favorites.l 
 end 
 else 
 link_to favorites_path('clipping', clipping.id), :method => :post, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 end 
 end 
 
 when 'posts' 
 render :partial => 'posts/meta', :locals => {:post => @favorite.favoritable} 
 end 

  end

  def show
    @favorite = @user.favorites.find(params[:id])
  end

  def index
    @favorites = Favorite.recent.by_user(@user).page(params[:page])
 @page_title = "#{@user.login}'s "+:favorites.l 
 @favorites.each do |f| 
  case favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
  
 when 'posts' 
  link_to post.title, user_post_path(post.user, post) 
 link_to :by.l(:login => post.user.login), user_path(post.user) 
 link_to image_tag(post.image_for_excerpt), user_post_path(post.user, post) 
 truncate_words(post.post, 7, '...' ) 
 link_to :more.l, user_post_path(post.user, post)
     
 end 
 
 end 
 paginate @favorites, :theme => 'bootstrap'      

  end


end
