class Admin::Merchandise::Wizards::PropertiesController < Admin::Merchandise::Wizards::BaseController
  def index
    form_info
  end

  def create
    property = Property.new(allowed_params)
    flash[:notice] = "Successfully created property." if property.save
    form_info
    render :action => 'index'
 
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

 render partial: '/admin/merchandise/wizards/sub_header'
 if  @properties.empty? 
 else 
 end 
 form_for @property, url: admin_merchandise_wizards_property_path(:id => 0), method: 'PUT' do |product_form| 
 select_tag 'property[ids][]',
                    options_from_collection_for_select(@properties, "id", "full_name", @selected),
                    :class => 'chzn-select  column',
                    :multiple => 'true',
                    :style    => 'overflow:scroll; width: 350px',
                    'data-placeholder' => 'Choose Properties' 
 product_form.submit 'Use Properties', :class => 'button' 
 end 
 unless  @properties.empty? 
 end 
 form_for @property, url: admin_merchandise_wizards_properties_path do |property_form| 
 render partial: 'form', locals: { form: property_form } 
 end 
 unless  @prototypes.empty? 
 @prototypes.each do |prototype|
 cycle '', '', 'last' 
 prototype.name 
 button_to 'Use', admin_merchandise_wizards_prototype_path(prototype),
                      :class => 'button secondary inline-block',
                      :method => :put 
 end 
 end 
 content_for :head do 
 stylesheet_link_tag 'chosen.css' 
 end 
 content_for :below_body do 
 javascript_include_tag 'chosen/chosen.jquery.min.js' 
 javascript_include_tag 'admin/wizards/properties.js' 
 end 

 end

  def update
    if params[:property] &&  valid_property_ids
      session[:product_wizard] ||= {}
      session[:product_wizard][:property_ids] = params[:property][:ids].map(&:to_i)
      flash[:notice] = "Successfully added properties."
      redirect_to next_form
    else
      flash[:notice] = "Please select at least one property."
      form_info
      render :action => 'index'
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

 render partial: '/admin/merchandise/wizards/sub_header'
 if  @properties.empty? 
 else 
 end 
 form_for @property, url: admin_merchandise_wizards_property_path(:id => 0), method: 'PUT' do |product_form| 
 select_tag 'property[ids][]',
                    options_from_collection_for_select(@properties, "id", "full_name", @selected),
                    :class => 'chzn-select  column',
                    :multiple => 'true',
                    :style    => 'overflow:scroll; width: 350px',
                    'data-placeholder' => 'Choose Properties' 
 product_form.submit 'Use Properties', :class => 'button' 
 end 
 unless  @properties.empty? 
 end 
 form_for @property, url: admin_merchandise_wizards_properties_path do |property_form| 
 render partial: 'form', locals: { form: property_form } 
 end 
 unless  @prototypes.empty? 
 @prototypes.each do |prototype|
 cycle '', '', 'last' 
 prototype.name 
 button_to 'Use', admin_merchandise_wizards_prototype_path(prototype),
                      :class => 'button secondary inline-block',
                      :method => :put 
 end 
 end 
 content_for :head do 
 stylesheet_link_tag 'chosen.css' 
 end 
 content_for :below_body do 
 javascript_include_tag 'chosen/chosen.jquery.min.js' 
 javascript_include_tag 'admin/wizards/properties.js' 
 end 

 end

  private


  def allowed_params
    params.require(:property).permit(:identifing_name, :display_name, :active)
  end

  def valid_property_ids
    params[:property][:ids] && !params[:property][:ids].empty? && params[:property][:ids].all? {|id| Property.find_by_id(id) }
  end

  def form_info
    @prototypes ||= Prototype.all
    @properties ||= Property.all
    @property ||= Property.new
    @selected ||= session[:product_wizard][:property_ids] || []
  end
end
