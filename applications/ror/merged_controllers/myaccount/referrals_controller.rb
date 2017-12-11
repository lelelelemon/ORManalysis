class Myaccount::ReferralsController < Myaccount::BaseController
  helper_method :sort_column, :sort_direction
  def index
    @referral  = Referral.new
    @referrals = current_user.referrals.order(sort_column + " " + sort_direction)
  end

  def create
    @referral = current_user.referrals.new(allowed_params)
    @referral.referral_type_id = ReferralType::DIRECT_WEB_FORM_ID
    if @referral.save
      redirect_to myaccount_referrals_url, :notice => "Successfully created referral."
    else
      @referrals = current_user.referrals.order(sort_column + " " + sort_direction)
      render :index
    end
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag('ie.css', media: 'screen, projection')
 stylesheet_link_tag('ie6.css', media: 'screen, projection') 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render partial: '/shared/welcome_header'
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 "myaccount" if myaccount_tab 
 if myaccount_tab 
 site_name 
 render :partial => '/shared/myaccount_subheader' 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 javascript_include_tag 'application' 
 yield :bottom 
 yield :below_body 

 end

  def update
    @referral = current_user.referrals.find(params[:id])
    if @referral.update_attributes(allowed_params)
      redirect_to myaccount_referrals_url, :notice  => "Successfully updated referral."
    else
      @referrals = current_user.referrals.order(sort_column + " " + sort_direction)
      render :index
    end
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag('ie.css', media: 'screen, projection')
 stylesheet_link_tag('ie6.css', media: 'screen, projection') 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render partial: '/shared/welcome_header'
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 "myaccount" if myaccount_tab 
 if myaccount_tab 
 site_name 
 render :partial => '/shared/myaccount_subheader' 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 javascript_include_tag 'application' 
 yield :bottom 
 yield :below_body 

 end

  private

    def allowed_params
      params.require(:referral).permit(:email, :name)
    end

    def selected_myaccount_tab(tab)
      tab == 'referrals'
    end

    def sort_column
      Referral.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
