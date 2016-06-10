class Skyline::ArticlesController < Skyline::ApplicationController
  
  # insert_before_filter_after :authentication, :find_article, :only => [:edit, :update, :destroy]
  set_callback :authenticate, :after, :find_article, :if => lambda{|c| %w{edit update destroy}.include?(c.action_name)  }
  
  authorize :index, :by => Proc.new{|user,controller,action| user.allow?(controller.article || controller.class_from_type, :index)  }
  authorize :create, :by => Proc.new{|user,controller,action| user.allow?(controller.article || controller.class_from_type, :create)  }  
  authorize :edit, :by => Proc.new{|user,controller,action| user.allow?(controller.article || controller.class_from_type, :show)  }  
  authorize :update, :reorder, :by => Proc.new{|user,controller,action| user.allow?(controller.article || controller.class_from_type, :update)  }  
  authorize :destroy, :by => Proc.new{|user,controller,action| user.allow?(controller.article || controller.class_from_type, :variant_delete)  }  
    
  layout :determine_layout
  
  self.default_menu = :content_library

  def index
    case params[:type] 
    when "skyline/page" 
      return redirect_to(edit_skyline_article_path(Skyline::Page.root))
    when "skyline/page_fragment"
      return redirect_to(edit_skyline_article_path(Skyline::PageFragment.first)) if Skyline::PageFragment.first.present?
    end
    @articles = class_from_type(params[:type]).all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 controller.class_from_type.model_name.human(:count => 2) 
 if @articles.any? 
 begin 
 render :partial => "skyline/articles/#{controller.class_from_type.name.demodulize.underscore}/list" 
 rescue ActionView::MissingTemplate 
 render :partial => "list" 
 end 
 else 
 t(:blank, :scope => [:article, :index], :name => controller.class_from_type.model_name.human(:count => 2).downcase) 
 end 
 t(:actions, :scope => [:article, :headers]) 
 link_to button_text(:new), skyline_articles_path(:type => params[:type]), :method => :post, :class => "add button medium green" 

end

  end
  
  def create
    if params[:type] == "skyline/page"
      relative_to_page = Skyline::Page.find_by_id(params[:article_id])
      return redirect_to(edit_skyline_article_path(Skyline::Page.root)) unless relative_to_page
      article = relative_to_page.create_new!(params[:position].to_sym)
    else
      article = class_from_type(params[:type]).new(params[:article])
      article.save
    end
    
    if article.errors.any?
      messages[:error] = t(:error, :errors => Array(article.errors.full_messages).to_sentence, :scope => [article.class, :create, :flashes])
      if params[:type] == "skyline/page"
        @target = edit_skyline_article_path(relative_to_page)
      else
        @target = skyline_articles_path(:type => params[:type])
      end
    else
      @target = edit_skyline_article_path(article)
      flash[:select_page_title] = true
    end
    
    if request.xhr?
      javascript_redirect_to @target
    else
		  redirect_to @target
  	end
  end

  def edit  
    case @article
      when Skyline::Page,Skyline::PageFragment then self.current_menu_item = :pages
    end
    
    can_edit_article = @article.editable_by?(current_user)
    if can_edit_article  && @variant.editable_by?(current_user)
      @variant.edit_by!(current_user)
    else
      messages.now[:error] = can_edit_article ? render_to_string(:partial => "currently_editing") : t(:not_allowed, :scope => [:article, :edit])
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @article.class.model_name.human 
 @variant.data.title 
 @article.previewable? ? skyline_article_article_version_url(@article, @variant) : "javascript:''" 
 @article.previewable? ? "data-url-\"#{skyline_article_article_version_url(@article, @variant)}\"" : '' 
 t(:actions, :scope => [:article, :headers]) 
  plugin_hook :top 
 t(:general, :scope => [:article, :headers]) 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 t(:current_variant, :scope => [:article, :edit]) 
 form_tag edit_skyline_article_path(@article), {:method => :get, :id => "change_variant_form"} do 
 select_tag "variant_id", 
                  options_for_select(
                      @article.variants.map{|v| ["#{v.name}#{" (#{t(:published, :scope => [:article, :edit])})" if v.published_variant?}",v.id] }, 
                      @variant.id), 
                  :id => "new_variant_id", :style => "width: 100%" 
 end 
 javascript_tag("$('new_variant_id').addEvent('change', function(){PageHelper.newVariantSelected(this.value)});") 
 end 
 t(:created_at, :scope => [:article, :edit]) 
 l(@variant.created_at, :format => :short) 
 if @variant.creator 
 @variant.creator.display_name 
 end 
 t(:updated_at, :scope => [:article, :edit]) 
 l(@variant.updated_at, :format => :short) 
 if @variant.last_updated_by 
 @variant.last_updated_by.display_name 
 end 
 if @article.class.publishable? 
 t(:publication, :scope => [:article, :headers]) 
 t(:publication_status, :scope => [:article, :edit]) 
 @article.class.model_name.human 
 tick_image(@article.published?) 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 if @article.published? 
 t(:current_variant, :scope => [:article, :edit]) 
 tick_image(@variant.published_variant?) 
 end 
 end 
 if @variant.published_variant? 
 t(:identical_published_variant, :scope => [:article, :edit]) 
 tick_image(@variant.identical_published_variant?) 
 end 
 if @article.publications.any? 
 if @article.published? && !@variant.published_variant? 
 t(:published_variant, :scope => [:article, :edit]) 
 link_to @article.published_publication.variant.name, edit_skyline_article_path(@article, :variant_id => @article.published_publication.variant) 
 end 
 t(:last_published, :scope => [:article, :edit]) 
 l(@article.publications.first.created_at, :format => :short) 
 if @article.publications.first.last_updated_by 
 @article.publications.first.last_updated_by.display_name  
 end 
 if @article.keep_history? 
 t(:publication_history, :scope => [:article, :edit]) 
 t(:number_of_publications, :count => @article.publications.size, :scope => [@article.class, :edit]).html_safe 
 link_to( 
                    t(:publication_history_link, :scope => [:article, :edit]), 
                    skyline_article_publications_path(@article), 
                    :method => :get, 
                    :remote => true) 
 end 
 end 
 if !@variant.identical_published_variant? && @variant.editable_by?(current_user) 
 submit_button_to :publish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :class => "medium green" 
 end 
 if @article.published? && @variant.editable_by?(current_user) 
 if @article.depublishable? 
 submit_button_to :depublish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :method => :delete, :class => "small red" 
 else 
 submit_button_to :depublish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 end 
 end 
  if Skyline::Configuration.enable_locking && @article.lockable? 
 t(:security, :scope => [:article, :headers]) 
 t(:locked_state, :scope => [:article, :edit]) 
 image_tag "#{Skyline::Configuration.url_prefix}/images/icons/lock#{"-open" unless @article.locked? }.gif" 
 if  @variant.editable_by?(current_user) && current_user.allow?(@article, :lock) 
 skyline_form_for(@article, {:as => :article, :url => skyline_article_path(@article, :variant_id => @variant), :html => {:method => "put"}, :remote => true}) do |f| 
 if @article.locked? 
 f.hidden_field :locked, :value => "0" 
 submit_button :unlock, :class => "small" 
 else 
 f.hidden_field :locked, :value => "1" 
 submit_button :lock, :class => "small" 
 end 
 end 
 end 
 end 
 
 if current_user.allow?(:page_update) 
 t(:advanced, :scope => [:article, :headers]) 
 delete_button_alt = t(:delete, :scope => [@article.class, :buttons]) 
 if @article.destroyable? && @variant.editable_by?(current_user) 
 submit_button_to delete_button_alt, skyline_article_path(@article), :method => :delete, :class => "small red", :confirm => t(:confirm_delete, :scope => [@article.class, :edit]) 
 else 
 submit_button_to delete_button_alt, skyline_article_path(@article), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 if @variant.destroyable? && @variant.editable_by?(current_user) 
 submit_button_to :delete_variant, skyline_article_variant_path(@article, @variant), :method => :delete, :class => "small", :confirm => t(:confirm_delete_variant, :scope => [:article,:edit]) 
 else 
 submit_button_to :delete_variant, skyline_article_variant_path(@article, @variant), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 submit_button_to :new_variant, skyline_article_variants_path(@article), :class => "small" 
 submit_button_to :copy_variant, skyline_article_variants_path(@article, :variant_id => @variant.id), :class => "small" 
 end 
 end 
 

end

    end
    
    if flash[:show_errors_for_publication]
      @variant.data.to_be_published = true
      @variant.valid?
    end
    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 skyline_form_for @article, {:as => :article, :url => skyline_article_path(@article), :html => {:method => :put, :id => "page_form"}} do |a| 
 a.fields_for :variants_attributes, @variant, :index => 1 do |v| 
 v.fields_for :data_attributes, v.object.data do |vd| 
 hidden_field_tag :clone_variant, "0" 
 v.hidden_field :id 
 v.hidden_field :version 
 vd.hidden_field :id 
 vd.hidden_field :class, :value => a.object.data_class.name if vd.object.new_record? 
 a.object.class.model_name.human 
 vd.object.title 
 begin 
 content = capture do  
 partial_content = render(:partial => "skyline/articles/#{a.object.class.name.demodulize.underscore}/header", :locals => {:a => a, :v => v, :vd => vd}) 
 if partial_content.present?  
 partial_content 
 end 
 end 
 rescue ActionView::MissingTemplate 
 content = "" 
 end 
 content 
 if Skyline::Rendering::Renderer.renderables(:sections, a.object.class).present? 
 menu_button t(:add_section, :scope => [:article, :edit]), :id => "add_section_button" do 
 Skyline::Rendering::Renderer.renderables(:sections, a.object.class).each do |section| 
 link_to(
                                section.model_name.human, 
                                new_skyline_section_path(:sectionable_type => section.name, :object_name => v.object_name_with_index, :renderable_scope => @renderable_scope.serialize)) 
 end 
 end 
 end 
 begin 
 content = capture do  
 render :partial => "skyline/articles/#{a.object.class.name.demodulize.underscore}/data", :locals => {:a => a, :v => v, :vd => vd} 
 end 
 rescue ActionView::MissingTemplate 
 content = "" 
 end 
 content 
 v.object.sections.each do |section| 
  sectionable_type = section.sectionable.andand.class.to_s.demodulize.underscore 
guid
 sectionable_type.camelcase(:lower) 
 section.sectionable.andand.errors.any? ? "invalid" : "" 
 variant_form.fields_for "sections_attributes", section, :index => guid do |section_form| 
 section_form.hidden_field :id unless section_form.object.new_record? 
 section_form.hidden_field :_destroy, :class => "delete" 
 section_form.positioning_field 
 section_form.fields_for "sectionable_attributes", section_form.object.sectionable do |sectionable_form| 
 sectionable_form.hidden_field :id unless sectionable_form.object.new_record? 
 sectionable_form.hidden_field :class if sectionable_form.object.new_record? 
 link_to_function button_text(:undo), "PageHelper.unDestroy('section_#{guid}')", :class => "undo button small" 
 t(:will_be_destroyed, :section => section.sectionable.class.model_name.human, :scope => [:section, :form]) 
 if section.sectionable.default_interface 
 renderable_templates_select(section.sectionable, section_form) 
 section.sectionable.class.model_name.human 
 render :partial => "skyline/sections/#{sectionable_type}", :locals => {:section_form => section_form, :sectionable_form => sectionable_form, :guid => guid} 
 else 
 render :partial => "skyline/sections/#{sectionable_type}", :locals => {:section_form => section_form, :sectionable_form => sectionable_form, :guid => guid} 
 end 
 end 
 end 
 link_to_function(image_tag("#{Skyline::Configuration.url_prefix}/images/buttons/section-delete.gif", :alt => t(:delete, :scope => [:section, :form])), "PageHelper.destroy('section_#{guid}')", :class => "delete") 
 javascript_tag "PageHelper.destroy('section_#{guid}');" if section.marked_for_destruction? 
 
 end 
 if a.object.previewable? 
 skyline_article_article_version_url(@article, @variant) 
 end 
 t(:editor, :scope => [:article, :tabs]) 
 if a.object.previewable? 
 t(:preview, :scope => [:article, :tabs]) 
 end 
 submit_button :save, :class => "green medium" 
 end 
 end 
 end 
 t(:actions, :scope => [:article, :headers]) 
  plugin_hook :top 
 t(:general, :scope => [:article, :headers]) 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 t(:current_variant, :scope => [:article, :edit]) 
 form_tag edit_skyline_article_path(@article), {:method => :get, :id => "change_variant_form"} do 
 select_tag "variant_id", 
                  options_for_select(
                      @article.variants.map{|v| ["#{v.name}#{" (#{t(:published, :scope => [:article, :edit])})" if v.published_variant?}",v.id] }, 
                      @variant.id), 
                  :id => "new_variant_id", :style => "width: 100%" 
 end 
 javascript_tag("$('new_variant_id').addEvent('change', function(){PageHelper.newVariantSelected(this.value)});") 
 end 
 t(:created_at, :scope => [:article, :edit]) 
 l(@variant.created_at, :format => :short) 
 if @variant.creator 
 @variant.creator.display_name 
 end 
 t(:updated_at, :scope => [:article, :edit]) 
 l(@variant.updated_at, :format => :short) 
 if @variant.last_updated_by 
 @variant.last_updated_by.display_name 
 end 
 if @article.class.publishable? 
 t(:publication, :scope => [:article, :headers]) 
 t(:publication_status, :scope => [:article, :edit]) 
 @article.class.model_name.human 
 tick_image(@article.published?) 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 if @article.published? 
 t(:current_variant, :scope => [:article, :edit]) 
 tick_image(@variant.published_variant?) 
 end 
 end 
 if @variant.published_variant? 
 t(:identical_published_variant, :scope => [:article, :edit]) 
 tick_image(@variant.identical_published_variant?) 
 end 
 if @article.publications.any? 
 if @article.published? && !@variant.published_variant? 
 t(:published_variant, :scope => [:article, :edit]) 
 link_to @article.published_publication.variant.name, edit_skyline_article_path(@article, :variant_id => @article.published_publication.variant) 
 end 
 t(:last_published, :scope => [:article, :edit]) 
 l(@article.publications.first.created_at, :format => :short) 
 if @article.publications.first.last_updated_by 
 @article.publications.first.last_updated_by.display_name  
 end 
 if @article.keep_history? 
 t(:publication_history, :scope => [:article, :edit]) 
 t(:number_of_publications, :count => @article.publications.size, :scope => [@article.class, :edit]).html_safe 
 link_to( 
                    t(:publication_history_link, :scope => [:article, :edit]), 
                    skyline_article_publications_path(@article), 
                    :method => :get, 
                    :remote => true) 
 end 
 end 
 if !@variant.identical_published_variant? && @variant.editable_by?(current_user) 
 submit_button_to :publish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :class => "medium green" 
 end 
 if @article.published? && @variant.editable_by?(current_user) 
 if @article.depublishable? 
 submit_button_to :depublish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :method => :delete, :class => "small red" 
 else 
 submit_button_to :depublish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 end 
 end 
  if Skyline::Configuration.enable_locking && @article.lockable? 
 t(:security, :scope => [:article, :headers]) 
 t(:locked_state, :scope => [:article, :edit]) 
 image_tag "#{Skyline::Configuration.url_prefix}/images/icons/lock#{"-open" unless @article.locked? }.gif" 
 if  @variant.editable_by?(current_user) && current_user.allow?(@article, :lock) 
 skyline_form_for(@article, {:as => :article, :url => skyline_article_path(@article, :variant_id => @variant), :html => {:method => "put"}, :remote => true}) do |f| 
 if @article.locked? 
 f.hidden_field :locked, :value => "0" 
 submit_button :unlock, :class => "small" 
 else 
 f.hidden_field :locked, :value => "1" 
 submit_button :lock, :class => "small" 
 end 
 end 
 end 
 end 
 
 if current_user.allow?(:page_update) 
 t(:advanced, :scope => [:article, :headers]) 
 delete_button_alt = t(:delete, :scope => [@article.class, :buttons]) 
 if @article.destroyable? && @variant.editable_by?(current_user) 
 submit_button_to delete_button_alt, skyline_article_path(@article), :method => :delete, :class => "small red", :confirm => t(:confirm_delete, :scope => [@article.class, :edit]) 
 else 
 submit_button_to delete_button_alt, skyline_article_path(@article), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 if @variant.destroyable? && @variant.editable_by?(current_user) 
 submit_button_to :delete_variant, skyline_article_variant_path(@article, @variant), :method => :delete, :class => "small", :confirm => t(:confirm_delete_variant, :scope => [:article,:edit]) 
 else 
 submit_button_to :delete_variant, skyline_article_variant_path(@article, @variant), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 submit_button_to :new_variant, skyline_article_variants_path(@article), :class => "small" 
 submit_button_to :copy_variant, skyline_article_variants_path(@article, :variant_id => @variant.id), :class => "small" 
 end 
 end 
 
 begin 
 content = capture do  
 render :partial => "skyline/articles/#{@article.class.name.demodulize.underscore}/meta" 
 end 
 rescue ActionView::MissingTemplate 
 content = "" 
 end 
 content 
 if Skyline::Configuration.enable_enforce_only_one_user_editing 
 Skyline::Configuration.url_prefix 
 @variant.id 
 end 

end

  end
  
  def update
    return handle_unauthorized_user unless @article.editable_by?(current_user)
    
    case @article
      when Skyline::Page,Skyline::PageFragment then self.current_menu_item = :pages
    end
        
    # @page.attributes= with all variant_attributes will load all variants which in turn
    #   will cause all versions of the variants to be increased by 1
    # Solution is to save the one and only variant seperately
    article_params = params[:article].dup if params[:article]
    if variant_attributes = article_params.andand[:variants_attributes].andand["1"]
      article_params.delete(:variants_attributes)
      variant_id = variant_attributes.delete(:id)
      @variant = @article.variants.find(variant_id)
    elsif params[:variant_id]
      @variant = @article.variants.find(params[:variant_id])
    end    

    if params["clone_variant"] == "1"
      name = variant_attributes.andand[:name]
      name = @variant.name + "_copy" if name.blank?
      new_variant = @article.variants.build(:name => name)
      new_variant.current_editor_id = current_user.id
      new_variant.save
    end

    
    @saved = false
    begin
      Skyline::Article.transaction do
        if params["clone_variant"] == "1"
          @variant = @variant.dup_variant_with(new_variant, variant_attributes)
          
          # Dirty hack so AR thinks this object isn't new.
          class << @variant; def new_record?; false; end; end
          @variant.save!
        else
          should_lock = article_params.delete(:locked)
          if should_lock
            return handle_unauthorized_user unless current_user.allow?(:page_lock)
            @article.locked = should_lock
          end
          @article.attributes = article_params          
          @article.save!
          
          if variant_attributes
            @variant.attributes = variant_attributes 
            @variant.save!
          end          
        end
        @saved = true
      end
    rescue ActiveRecord::RecordInvalid
      logger.debug "Article update failed: #{@article.errors.inspect}"
      logger.debug "Variant update failed: #{@variant.errors.inspect}"
    end
    
    if params[:article].has_key?(:move_behind)
      render :nothing => true
    elsif request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @saved 
 if @article.locked? 
 notification :success, t(:locked, :scope => [@article.class, :update, :flashes]) 
 if @article.kind_of?(Skyline::Page) 
 @article.id 
 end 
 else 
 notification :success, t(:unlocked, :scope => [@article.class, :update, :flashes]) 
 if @article.kind_of?(Skyline::Page) 
 @article.id 
 end 
 end 
 else 
 if @article.locked? 
 message :error, t(:lock_failed, :scope => [@article.class, :update, :flashes]) 
 else 
 message :error, t(:unlock_failed, :scope => [@article.class, :update, :flashes]) 
 end 
 end 
  if Skyline::Configuration.enable_locking && @article.lockable? 
 t(:security, :scope => [:article, :headers]) 
 t(:locked_state, :scope => [:article, :edit]) 
 image_tag "#{Skyline::Configuration.url_prefix}/images/icons/lock#{"-open" unless @article.locked? }.gif" 
 if  @variant.editable_by?(current_user) && current_user.allow?(@article, :lock) 
 skyline_form_for(@article, {:as => :article, :url => skyline_article_path(@article, :variant_id => @variant), :html => {:method => "put"}, :remote => true}) do |f| 
 if @article.locked? 
 f.hidden_field :locked, :value => "0" 
 submit_button :unlock, :class => "small" 
 else 
 f.hidden_field :locked, :value => "1" 
 submit_button :lock, :class => "small" 
 end 
 end 
 end 
 end 
 

end

    else
      if @saved
        notifications[:success] = t(:success, :scope => [@article.class, :update, :flashes])
        redirect_to edit_skyline_article_path(@article, :variant_id => @variant.id)
      else
        if @variant.errors[:version].any?
          messages.now[:error] = @variant.errors[:version]
        else
          messages.now[:error] = t(:error, :scope => [@article.class, :update, :flashes])
        end
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 skyline_form_for @article, {:as => :article, :url => skyline_article_path(@article), :html => {:method => :put, :id => "page_form"}} do |a| 
 a.fields_for :variants_attributes, @variant, :index => 1 do |v| 
 v.fields_for :data_attributes, v.object.data do |vd| 
 hidden_field_tag :clone_variant, "0" 
 v.hidden_field :id 
 v.hidden_field :version 
 vd.hidden_field :id 
 vd.hidden_field :class, :value => a.object.data_class.name if vd.object.new_record? 
 a.object.class.model_name.human 
 vd.object.title 
 begin 
 content = capture do  
 partial_content = render(:partial => "skyline/articles/#{a.object.class.name.demodulize.underscore}/header", :locals => {:a => a, :v => v, :vd => vd}) 
 if partial_content.present?  
 partial_content 
 end 
 end 
 rescue ActionView::MissingTemplate 
 content = "" 
 end 
 content 
 if Skyline::Rendering::Renderer.renderables(:sections, a.object.class).present? 
 menu_button t(:add_section, :scope => [:article, :edit]), :id => "add_section_button" do 
 Skyline::Rendering::Renderer.renderables(:sections, a.object.class).each do |section| 
 link_to(
                                section.model_name.human, 
                                new_skyline_section_path(:sectionable_type => section.name, :object_name => v.object_name_with_index, :renderable_scope => @renderable_scope.serialize)) 
 end 
 end 
 end 
 begin 
 content = capture do  
 render :partial => "skyline/articles/#{a.object.class.name.demodulize.underscore}/data", :locals => {:a => a, :v => v, :vd => vd} 
 end 
 rescue ActionView::MissingTemplate 
 content = "" 
 end 
 content 
 v.object.sections.each do |section| 
  sectionable_type = section.sectionable.andand.class.to_s.demodulize.underscore 
guid
 sectionable_type.camelcase(:lower) 
 section.sectionable.andand.errors.any? ? "invalid" : "" 
 variant_form.fields_for "sections_attributes", section, :index => guid do |section_form| 
 section_form.hidden_field :id unless section_form.object.new_record? 
 section_form.hidden_field :_destroy, :class => "delete" 
 section_form.positioning_field 
 section_form.fields_for "sectionable_attributes", section_form.object.sectionable do |sectionable_form| 
 sectionable_form.hidden_field :id unless sectionable_form.object.new_record? 
 sectionable_form.hidden_field :class if sectionable_form.object.new_record? 
 link_to_function button_text(:undo), "PageHelper.unDestroy('section_#{guid}')", :class => "undo button small" 
 t(:will_be_destroyed, :section => section.sectionable.class.model_name.human, :scope => [:section, :form]) 
 if section.sectionable.default_interface 
 renderable_templates_select(section.sectionable, section_form) 
 section.sectionable.class.model_name.human 
 render :partial => "skyline/sections/#{sectionable_type}", :locals => {:section_form => section_form, :sectionable_form => sectionable_form, :guid => guid} 
 else 
 render :partial => "skyline/sections/#{sectionable_type}", :locals => {:section_form => section_form, :sectionable_form => sectionable_form, :guid => guid} 
 end 
 end 
 end 
 link_to_function(image_tag("#{Skyline::Configuration.url_prefix}/images/buttons/section-delete.gif", :alt => t(:delete, :scope => [:section, :form])), "PageHelper.destroy('section_#{guid}')", :class => "delete") 
 javascript_tag "PageHelper.destroy('section_#{guid}');" if section.marked_for_destruction? 
 
 end 
 if a.object.previewable? 
 skyline_article_article_version_url(@article, @variant) 
 end 
 t(:editor, :scope => [:article, :tabs]) 
 if a.object.previewable? 
 t(:preview, :scope => [:article, :tabs]) 
 end 
 submit_button :save, :class => "green medium" 
 end 
 end 
 end 
 t(:actions, :scope => [:article, :headers]) 
  plugin_hook :top 
 t(:general, :scope => [:article, :headers]) 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 t(:current_variant, :scope => [:article, :edit]) 
 form_tag edit_skyline_article_path(@article), {:method => :get, :id => "change_variant_form"} do 
 select_tag "variant_id", 
                  options_for_select(
                      @article.variants.map{|v| ["#{v.name}#{" (#{t(:published, :scope => [:article, :edit])})" if v.published_variant?}",v.id] }, 
                      @variant.id), 
                  :id => "new_variant_id", :style => "width: 100%" 
 end 
 javascript_tag("$('new_variant_id').addEvent('change', function(){PageHelper.newVariantSelected(this.value)});") 
 end 
 t(:created_at, :scope => [:article, :edit]) 
 l(@variant.created_at, :format => :short) 
 if @variant.creator 
 @variant.creator.display_name 
 end 
 t(:updated_at, :scope => [:article, :edit]) 
 l(@variant.updated_at, :format => :short) 
 if @variant.last_updated_by 
 @variant.last_updated_by.display_name 
 end 
 if @article.class.publishable? 
 t(:publication, :scope => [:article, :headers]) 
 t(:publication_status, :scope => [:article, :edit]) 
 @article.class.model_name.human 
 tick_image(@article.published?) 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 if @article.published? 
 t(:current_variant, :scope => [:article, :edit]) 
 tick_image(@variant.published_variant?) 
 end 
 end 
 if @variant.published_variant? 
 t(:identical_published_variant, :scope => [:article, :edit]) 
 tick_image(@variant.identical_published_variant?) 
 end 
 if @article.publications.any? 
 if @article.published? && !@variant.published_variant? 
 t(:published_variant, :scope => [:article, :edit]) 
 link_to @article.published_publication.variant.name, edit_skyline_article_path(@article, :variant_id => @article.published_publication.variant) 
 end 
 t(:last_published, :scope => [:article, :edit]) 
 l(@article.publications.first.created_at, :format => :short) 
 if @article.publications.first.last_updated_by 
 @article.publications.first.last_updated_by.display_name  
 end 
 if @article.keep_history? 
 t(:publication_history, :scope => [:article, :edit]) 
 t(:number_of_publications, :count => @article.publications.size, :scope => [@article.class, :edit]).html_safe 
 link_to( 
                    t(:publication_history_link, :scope => [:article, :edit]), 
                    skyline_article_publications_path(@article), 
                    :method => :get, 
                    :remote => true) 
 end 
 end 
 if !@variant.identical_published_variant? && @variant.editable_by?(current_user) 
 submit_button_to :publish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :class => "medium green" 
 end 
 if @article.published? && @variant.editable_by?(current_user) 
 if @article.depublishable? 
 submit_button_to :depublish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :method => :delete, :class => "small red" 
 else 
 submit_button_to :depublish, skyline_article_published_publication_path(@article, :variant_id => @variant.id), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 end 
 end 
  if Skyline::Configuration.enable_locking && @article.lockable? 
 t(:security, :scope => [:article, :headers]) 
 t(:locked_state, :scope => [:article, :edit]) 
 image_tag "#{Skyline::Configuration.url_prefix}/images/icons/lock#{"-open" unless @article.locked? }.gif" 
 if  @variant.editable_by?(current_user) && current_user.allow?(@article, :lock) 
 skyline_form_for(@article, {:as => :article, :url => skyline_article_path(@article, :variant_id => @variant), :html => {:method => "put"}, :remote => true}) do |f| 
 if @article.locked? 
 f.hidden_field :locked, :value => "0" 
 submit_button :unlock, :class => "small" 
 else 
 f.hidden_field :locked, :value => "1" 
 submit_button :lock, :class => "small" 
 end 
 end 
 end 
 end 
 
 if current_user.allow?(:page_update) 
 t(:advanced, :scope => [:article, :headers]) 
 delete_button_alt = t(:delete, :scope => [@article.class, :buttons]) 
 if @article.destroyable? && @variant.editable_by?(current_user) 
 submit_button_to delete_button_alt, skyline_article_path(@article), :method => :delete, :class => "small red", :confirm => t(:confirm_delete, :scope => [@article.class, :edit]) 
 else 
 submit_button_to delete_button_alt, skyline_article_path(@article), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 if Skyline::Configuration.enable_multiple_variants && @article.can_have_multiple_variants? 
 if @variant.destroyable? && @variant.editable_by?(current_user) 
 submit_button_to :delete_variant, skyline_article_variant_path(@article, @variant), :method => :delete, :class => "small", :confirm => t(:confirm_delete_variant, :scope => [:article,:edit]) 
 else 
 submit_button_to :delete_variant, skyline_article_variant_path(@article, @variant), :method => :delete, :class => "small disabled", :disabled => true 
 end 
 submit_button_to :new_variant, skyline_article_variants_path(@article), :class => "small" 
 submit_button_to :copy_variant, skyline_article_variants_path(@article, :variant_id => @variant.id), :class => "small" 
 end 
 end 
 
 begin 
 content = capture do  
 render :partial => "skyline/articles/#{@article.class.name.demodulize.underscore}/meta" 
 end 
 rescue ActionView::MissingTemplate 
 content = "" 
 end 
 content 
 if Skyline::Configuration.enable_enforce_only_one_user_editing 
 Skyline::Configuration.url_prefix 
 @variant.id 
 end 

end

      end          
    end
    
    logger.debug("------ article validation: #{@article.errors.full_messages.inspect}")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @saved 
 if @article.locked? 
 notification :success, t(:locked, :scope => [@article.class, :update, :flashes]) 
 if @article.kind_of?(Skyline::Page) 
 @article.id 
 end 
 else 
 notification :success, t(:unlocked, :scope => [@article.class, :update, :flashes]) 
 if @article.kind_of?(Skyline::Page) 
 @article.id 
 end 
 end 
 else 
 if @article.locked? 
 message :error, t(:lock_failed, :scope => [@article.class, :update, :flashes]) 
 else 
 message :error, t(:unlock_failed, :scope => [@article.class, :update, :flashes]) 
 end 
 end 
  if Skyline::Configuration.enable_locking && @article.lockable? 
 t(:security, :scope => [:article, :headers]) 
 t(:locked_state, :scope => [:article, :edit]) 
 image_tag "#{Skyline::Configuration.url_prefix}/images/icons/lock#{"-open" unless @article.locked? }.gif" 
 if  @variant.editable_by?(current_user) && current_user.allow?(@article, :lock) 
 skyline_form_for(@article, {:as => :article, :url => skyline_article_path(@article, :variant_id => @variant), :html => {:method => "put"}, :remote => true}) do |f| 
 if @article.locked? 
 f.hidden_field :locked, :value => "0" 
 submit_button :unlock, :class => "small" 
 else 
 f.hidden_field :locked, :value => "1" 
 submit_button :lock, :class => "small" 
 end 
 end 
 end 
 end 
 

end

  end  
  
  def destroy
    return handle_unauthorized_user unless @article.editable_by?(current_user)

    if @article.destroyable?
      if @article.destroy
        notifications[:success] = t(:success, :scope => [@article.class, :destroy, :flashes])
        if @article.respond_to?(:parent) && @article.parent.present?
          redirect_to edit_skyline_article_path(@article.parent)
        else
          redirect_to skyline_articles_path(:type => @article.class)
        end
      else
        notifications[:error] = t(:error, :scope => [@article.class, :destroy, :flashes])
        redirect_to edit_skyline_article_path(@article)
      end
    else
      if @article.published?
        notifications[:error] = t(:error_page_published, :scope => [@article.class, :destroy, :flashes])
        redirect_to edit_skyline_article_path(@article)
      elsif @article.persistent?
        notifications[:error] = t(:error_page_persistent, :scope => [@article.class, :destroy, :flashes])
        redirect_to edit_skyline_article_path(@article)
      elsif @article.children.any?
        notifications[:error] = t(:error_page_has_children, :scope => [@article.class, :destroy, :flashes])
        redirect_to edit_skyline_article_path(@article)
      else
        notifications[:error] = t(:error, :scope => [@article.class, :destroy, :flashes])
        redirect_to edit_skyline_article_path(@article)
      end
    end
  end
  
	# expects:
	#   params[:pages]  - Array of Page IDs in the new order
  def reorder
  	return unless request.xhr?
  	Skyline::Page.reorder(params[:pages])
  	# TODO: render....
	end  

  # =============================
  # = Non action public methods =
  # =============================
  hide_action :article, :class_from_type
  
  def article
    @article
  end
    
  def class_from_type(type=params[:type])
    raise "Cannot infer class from #{type.inspect}" if type.blank?
    @klass = type.camelcase.constantize
    if @klass.ancestors.include?(Skyline::Article)
      return @klass 
    else
      raise "Class #{klass.to_s} is not a subclass of Skyline::Article"
    end
  end

  protected
  
  def find_article
    @article = Skyline::Article.find_by_id(params[:id])
    @variant = @article.variants.find_by_id(params[:variant_id]) if params[:variant_id]
    @variant ||= @article.default_variant
    @variant ||= @article.variants.first
    @renderable_scope = @article.renderable_scope
  end
  
  def determine_layout
    if @article && (@article.kind_of?(Skyline::Page) || @article.kind_of?(Skyline::PageFragment)) || params[:type] == "skyline/page" || params[:type] == "skyline/page_fragment"
      "skyline/layouts/pages"
    else
      "skyline/layouts/articles"
    end
  end

end