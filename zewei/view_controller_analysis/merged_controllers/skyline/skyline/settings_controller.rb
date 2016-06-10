class Skyline::SettingsController < Skyline::Skyline2Controller
  
  layout "skyline/layouts/settings"
  
  self.default_menu = :admin
  
  authorize :index, :edit, :update, :by => :settings_update
  
  def index
    if @implementation.has_settings?
      redirect_to edit_skyline_setting_path(@implementation.settings.page_names.first)
    end
  end
  
  def edit
    @settings = @implementation.settings[params[:id]]
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :left do 
t(:group_title, :scope => [:settings]) 
 @implementation.settings.ordered_pages.each do |page| 
 link_to page.human_name, edit_skyline_setting_path(page.name), :class => (page.name == @settings.page.name ? "selected" : "") 
 end 
 end 
 skyline_form_for @settings, :as => :settings, :url => skyline_setting_path(@settings.page.name), :html => {:method => :put} do |f| 
 t(:title, :scope => [:settings], :class => @settings.page.human_name) 
 @settings.page.description 
 content_fields(@settings.page,:settings, @settings) 
 submit_button :save, :class => "medium green"  
 end 

end

  end
  
  def update
    @settings = @implementation.settings[params[:id]]
    @settings.data = params[:settings]
    if @settings.save
      notifications[:success] = t(:success, :scope => [:settings, :update, :flashes])
      redirect_to edit_skyline_setting_path(@settings.page.name)
    else
      messages.now[:error] = t(:error, :scope => [:settings, :update, :flashes])
    end
  end
  
end
