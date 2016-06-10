class Skyline::ProfilesController < Skyline::ApplicationController
  
  def edit
    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 dialog(t(:dialog_title, :display_name => current_user.display_name, :scope => [:user,:profile]), :partial => "edit", :width => 700) 

end

  end
  
  def update
    attributes = params[:user]
    current_user.force_password = attributes.andand.delete(:force_password)
    current_user.attributes = attributes
    current_user.editing_user = current_user
    
    # We use an instance variable because we want to use it in the render(:update) block.
    @saved = current_user.save
    
    if @saved
      notifications[:success] = t(:success, :scope => [:user,:profile,:flashes])
    else
      messages.now[:error] = t(:error,:scope => [:user,:profile,:flashes])
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_notifications_javascript 
 if @saved 
 else 
  skyline_form_for current_user, :as => :user, :url => skyline_profile_path(current_user), :remote => true, :method => :put do |f|
 f.label_with_text :current_password 
 f.password_field :current_password, :class => "full" 
 t(:current_password_info, :scope => [:user, :profile]) 
 f.label_with_text :name 
 f.text_field :name, :class => "full" 
 f.label :force_password, Skyline::User.human_attribute_name("password") 
 f.password_field :force_password, :class => "full" 
 t(:password_info, :scope => [:user,:edit]) 
 f.label :force_password_confirmation, f.t(:password_confirmation) 
 f.password_field :force_password_confirmation, :class => "full" 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.close()", :class => "cancel"  
 submit_button :save, :class => "small green"  
 render_messages(:area => "Skyline.Dialog.current.contentEl.getElement('.messageArea')") 
 end 
 
 end 

end

  end
  
end