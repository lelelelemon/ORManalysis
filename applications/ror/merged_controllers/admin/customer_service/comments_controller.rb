class Admin::CustomerService::CommentsController < Admin::CustomerService::BaseController
  helper_method :sort_column, :sort_direction, :customer
  def index
    @comments = customer.comments.order(sort_column + " " + sort_direction).
                                  paginate(page: pagination_page, per_page: pagination_rows)
  end

  def show
    @comment = customer.comments.find(params[:id])
  end

  def new
    @comment = customer.comments.new
  end

  def create
    @comment = current_user.customer_service_comments.new(allowed_params)
    @comment.user_id = customer.id
    @comment.created_by = current_user.id
    if @comment.save
      redirect_to [:admin, :customer_service, customer], notice: "Successfully created comment."
    else
      render :new
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

  private

    def allowed_params
      params.require(:comment).permit(:note)
    end

    def customer
      @customer ||= User.find(params[:user_id])
    end
    def sort_column
      Comment.column_names.include?(params[:sort]) ? params[:sort] : "note"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
