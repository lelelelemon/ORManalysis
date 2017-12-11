class Myaccount::CreditCardsController < Myaccount::BaseController
  def index
    @credit_cards = current_user.payment_profiles
  end

  def show
    @credit_card = current_user.payment_profiles.find(params[:id])
  end

  def new
    @credit_card = current_user.payment_profiles.new
  end

  def create
    @credit_card = current_user.payment_profiles.new(allowed_params)
    if @credit_card.save
      flash[:notice] = "Successfully created credit card."
      redirect_to myaccount_credit_card_url(@credit_card)
    else
      render :action => 'new'
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

 form_for(@credit_card, :url => myaccount_credit_cards_path(@credit_card)) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 
 link_to 'Back to List', myaccount_credit_cards_path, :class => 'button' 

 end

  def edit
    @credit_card = current_user.payment_profiles.find(params[:id])
  end

  def update
    @credit_card = current_user.payment_profiles.find(params[:id])
    if @credit_card.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated credit card."
      redirect_to myaccount_credit_card_url(@credit_card)
    else
      render :action => 'edit'
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

 form_for(@credit_card, :url => myaccount_credit_card_path(@credit_card)) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 
 link_to 'Show', myaccount_credit_card_path( @credit_card ), :class => 'button' 
 link_to 'View All', myaccount_credit_cards_path, :class => 'button' 

 end

  def destroy
    @credit_card = current_user.payment_profiles.find(params[:id])
    @credit_card.inactivate!
    flash[:notice] = "Successfully destroyed credit card."
    redirect_to myaccount_credit_cards_url
  end

  private

  def allowed_params
    params.require(:credit_card).permit(:address_id, :month, :year, :cc_type, :first_name, :last_name, :card_name)
  end

  def selected_myaccount_tab(tab)
    tab == 'credit_cards'
  end
end
