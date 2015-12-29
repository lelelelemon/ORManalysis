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
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.js
    end
  end

  def show
    @favorite = @user.favorites.find(params[:id])
  end

  def index
    @favorites = Favorite.recent.by_user(@user).page(params[:page])
 @page_title = "#{@user.login}'s "+:favorites.l 
 @favorites.each do |f| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 case favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
 render :partial => "clippings/clipping", :locals => {:clipping => favorite.favoritable} 
 when 'posts' 
 render :partial => "posts/favorited_post", :locals => {:post => favorite.favoritable}     
 end 
 end 


end

 
# end 
 paginate @favorites, :theme => 'bootstrap'      

  end


end
