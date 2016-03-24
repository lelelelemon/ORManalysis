require 'globalize'

module Shoppe
  class ProductLocalisationsController < ApplicationController
    before_filter { @active_nav = :products }
    before_filter { @product = Shoppe::Product.find(params[:product_id]) }
    before_filter { params[:id] && @localisation = @product.translations.find(params[:id]) }

    def index
      @localisations = @product.translations
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back'), [:edit, @product], :class => 'button' 
 link_to t('shoppe.localisations.new_localisation'), [:new, @product, :localisation], :class => 'button green' 
 t('shoppe.localisations.localisations_of', name: @product.name) 
 end 
 t('shoppe.localisations.language') 
 t('shoppe.products.name') 
 t('shoppe.products.permalink') 
 if @localisations.empty? 
 t('shoppe.localisations.no_localisations') 
 else 
 for localisation in @localisations 
 localisation.locale 
 link_to localisation.name, edit_product_localisation_path(@product, localisation) 
 localisation.permalink 
 end 
 end 

end

    end

    def new
      @localisation = @product.translations.new
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product, @localisation], :url => @localisation.new_record? ? product_localisations_path(@product) : product_localisation_path(@product, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product.category_details') do 
 f.label :name, t('shoppe.product.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.product.short_description') 
 f.text_area :short_description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_localisation_path(@product, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

    end

    def create
      if I18n.available_locales.include? safe_params[:locale].to_sym
        I18n.locale = safe_params[:locale].to_sym

        if @product.update(safe_params)
          I18n.locale = I18n.default_locale
          redirect_to [@product, :localisations], flash: { notice: t('shoppe.localisations.localisation_created') }
        else
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product, @localisation], :url => @localisation.new_record? ? product_localisations_path(@product) : product_localisation_path(@product, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product.category_details') do 
 f.label :name, t('shoppe.product.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.product.short_description') 
 f.text_area :short_description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_localisation_path(@product, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

        end
      else
        redirect_to [@product, :localisations]
      end
    end

    def edit
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product, @localisation], :url => @localisation.new_record? ? product_localisations_path(@product) : product_localisation_path(@product, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product.category_details') do 
 f.label :name, t('shoppe.product.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.product.short_description') 
 f.text_area :short_description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_localisation_path(@product, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

    end

    def update
      if @localisation.update(safe_params)
        redirect_to [@product, :localisations], flash: { notice: t('shoppe.localisations.localisation_updated') }
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product, @localisation], :url => @localisation.new_record? ? product_localisations_path(@product) : product_localisation_path(@product, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product.category_details') do 
 f.label :name, t('shoppe.product.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.product.short_description') 
 f.text_area :short_description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_localisation_path(@product, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
 end 
 end 

end

      end
    end

    def destroy
      @localisation.destroy
      redirect_to [@product, :localisations], flash: { notice: t('shoppe.localisations.localisation_destroyed') }
    end

    private

    def safe_params
      params[:product_translation].permit(:name, :locale, :permalink, :description, :short_description)
    end
  end
end
