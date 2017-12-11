class Admin::Fulfillment::CommentsController < Admin::Fulfillment::BaseController
  helper_method :order

  def index
    respond_to do |format|
      format.json { render json: order.comments.to_json, status: 206}
      format.html { render action: 'index' }
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 order.number 
 for comment in order.comments 
 cycle("odd", "")
 link_to comment.name, admin_fulfillment_order_comment_path(order, comment) 
 link_to "Edit", edit_admin_fulfillment_order_comment_path(order, comment) 
 link_to "Destroy", admin_fulfillment_order_comment_path(order, comment), :confirm => 'Are you sure?', :method => :delete 
 end 
 link_to "New Comment", new_admin_fulfillment_order_comment_path(order), :class => 'button' 

 end

  def show
    @comment = order.comments.find(params[:id])
    respond_to do |format|
      format.json { render json: @comment.to_json}
      format.html { render action: 'show' }
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 @comment.note 
 link_to "Edit", edit_admin_fulfillment_order_comment_path(order, @comment), :class => 'button' 
 link_to "Destroy", admin_fulfillment_order_comment_path(order, @comment), :data => {:confirm => 'Are you sure?'}, :method => :delete, :class => 'button' 
 link_to "View All", admin_fulfillment_order_comments_path(order), :class => 'button' 

 end

  def new
    @comment = order.comments.new
  end

  def create
    @comment              = order.comments.new(allowed_params)
    @comment.created_by   = current_user.id
    @comment.user_id      = order.user_id
    respond_to do |format|
      if @comment.save
        flash[:notice] = "Successfully created comment."
        format.json { render json: @comment.to_json}
        format.html { render action: 'show' }
      else
        format.json { render json: @comment.errors.to_json }
        format.html { render action: 'new' }
      end
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 end

  def edit
    @comment = order.comments.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(allowed_params)
        flash[:notice] = "Successfully updated comment."
        format.json { render json: @comment.to_json}
        format.html { redirect_to admin_fulfillment_order_comment_url(order, @comment) }
      else
        format.json { render json: @comment.errors.to_json }
        format.html { render action: 'edit' }
      end
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 end

  def destroy
    @comment = order.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to admin_fulfillment_order_comments_url(order)
  end

  private

  def allowed_params
    params.require(:comment).permit(:note)
  end

  def order
    @order ||= Order.find_by_number(params[:order_id])
  end
end
