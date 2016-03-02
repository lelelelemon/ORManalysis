# encoding: UTF-8
class TagsController < ApplicationController
  cache_sweeper :tag_sweeper, :only => [:update, :destroy]

  def index
    @tags = current_user.company.tags
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("tags.tags") 
 t("tags.name") 
 t("tags.task_info") 
 @tags.each do |tag| 
 link_to_filter_on_tag(tag) 
 t("tags.tag_count", open: tag.count, all: tag.total_count) 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_tag_path(tag) 
 end 

end

  end

  def edit
    @tag = current_user.company.tags.find(params[:id])

    if @tag.nil?
      flash[:error] = t('flash.alert.unauthorized_operation')
      redirect_to tags_path
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@tag) do |f| 
 t("tags.edit_tags", :tag => @tag.name) 
 f.label t("tags.name") 
 f.text_field :name 
 cit_submit_tag(@tag) 
 unless @tag.new_record? 
 link_to(t("button.delete"), tag_path(@tag), :class => "btn btn-danger", :method => :delete, :confirm => t("shared.are_you_sure")) 
 end 
 end 

end

  end

  def update
    @tag = current_user.company.tags.find(params[:id])

    if @tag and @tag.update_attributes(params[:tag])
      flash[:success] = t('flash.notice.model_updated', model: Tag.model_name.human)
    else
      flash[:error] = t('flash.alert.unauthorized_operation')
    end

    redirect_to tags_path
  end

  def destroy
    @tag = current_user.company.tags.find(params[:id])

    if @tag
      @tag.destroy
      flash[:success] = t('flash.notice.model_deleted', model: Tag.model_name.human)
    else
      flash[:error] = t('flash.alert.unauthorized_operation')
    end

    redirect_to tags_path
  end

  def auto_complete_for_tags
    value = params[:term]

    @tags = current_user.company.tags.where('name LIKE ?', '%' + value +'%')
    render :json=> @tags.collect{|tag| {:value => tag.name }}.to_json
  end
end
