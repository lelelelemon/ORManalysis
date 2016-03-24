require 'globalize'

module Shoppe
  class ProductCategoryLocalisationsController < ApplicationController
    before_filter { @active_nav = :product_categories }
    before_filter { @product_category = Shoppe::ProductCategory.find(params[:product_category_id]) }
    before_filter { params[:id] && @localisation = @product_category.translations.find(params[:id]) }

    def index
      @localisations = @product_category.translations
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back'), product_categories_path, :class => 'button' 
 link_to t('shoppe.localisations.new_localisation'), [:new, @product_category, :localisation], :class => 'button green' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 t('shoppe.localisations.language') 
 t('shoppe.products.name') 
 t('shoppe.products.permalink') 
 if @localisations.empty? 
 t('shoppe.localisations.no_localisations') 
 else 
 for localisation in @localisations 
 localisation.locale 
 link_to localisation.name, edit_product_category_localisation_path(@product_category, localisation) 
 localisation.permalink 
 end 
 end 

end

    end

    def new
      @localisation = @product_category.translations.new
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product_category, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product_category, @localisation], :url => @localisation.new_record? ? product_category_localisations_path(@product_category) : product_category_localisation_path(@product_category, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {selected: @localisation.locale || params[:locale_field]}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_category_localisation_path(@product_category, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

    end

    def create
      if I18n.available_locales.include? safe_params[:locale].to_sym
        I18n.locale = safe_params[:locale].to_sym

        if @product_category.update(safe_params)
          I18n.locale = I18n.default_locale
          redirect_to [@product_category, :localisations], flash: { notice: t('shoppe.localisations.localisation_created') }
        else
          render action: 'edit'
        end
      else
        redirect_to [@product_category, :localisations]
      end
    end

    def edit
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product_category, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product_category, @localisation], :url => @localisation.new_record? ? product_category_localisations_path(@product_category) : product_category_localisation_path(@product_category, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {selected: @localisation.locale || params[:locale_field]}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_category_localisation_path(@product_category, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

    end

    def update
      if @localisation.update(safe_params)
        redirect_to [@product_category, :localisations], notice: t('shoppe.localisations.localisation_updated')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product_category, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product_category, @localisation], :url => @localisation.new_record? ? product_category_localisations_path(@product_category) : product_category_localisation_path(@product_category, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {selected: @localisation.locale || params[:locale_field]}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_category_localisation_path(@product_category, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

      end
    end

    def destroy
      @localisation.destroy
      redirect_to [@product_category, :localisations], notice: t('shoppe.localisations.localisation_destroyed')
    end

    private

    def safe_params
      params[:product_category_translation].permit(:name, :locale, :permalink, :description)
    end
  end
end
