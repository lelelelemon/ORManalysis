class ScoreRulesController < ApplicationController
  include ScoreRulesHelper

  before_filter :get_container
  before_filter :validate_score_rule_id, :only => [:show, :edit, :update, :destroy]

  layout :false

  def index
    @score_rules = @container.score_rules
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @score_rules.any? 
  t("score_rules.name") 
 t("score_rules.score") 
 t("score_rules.exponent") 
 t("score_rules.score_type") 
 t("shared.actions") 
 render @score_rules, :container => @container 
 link_to t("button.new"),
            new_container_score_rule_path(@container),
            :class => 'new-score-rule ui-button' 
 
 else 
 t("score_rules.no_rules", container: @container.class.to_s.humanize) 
 t("score_rules.new_html", link: link_to(t("shared.here"), new_container_score_rule_path(@container), :class => 'new-score-rule')) 
 end 

end

  end

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render @score_rule, :container => @container 

end

  end

  def new
    @score_rule = @container.score_rules.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("score_rules.add_new") 
 t("score_rules.explanation", container: @container.class.to_s.humanize) 
  form_for @score_rule, :url => url, :html => {:class => "form-horizontal score_rule_form"} do |form| 
  if object.errors.any? 
 t("shared.form_errors") 
 object.errors.full_messages.each do |error_message| 
 error_message 
 end 
 end 
 
 end 
 

end

  end

  def create
    @score_rule = ScoreRule.new(params[:score_rule])

    if @score_rule.valid?
      @container.score_rules << @score_rule

      flash[:success] = t('flash.notice.model_created', model: ScoreRule.model_name.human)
      redirect_to container_score_rules_path(@container)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("score_rules.add_new") 
 t("score_rules.explanation", container: @container.class.to_s.humanize) 
  form_for @score_rule, :url => url, :html => {:class => "form-horizontal score_rule_form"} do |form| 
  if object.errors.any? 
 t("shared.form_errors") 
 object.errors.full_messages.each do |error_message| 
 error_message 
 end 
 end 
 
 end 
 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("score_rules.edit") 
  form_for @score_rule, :url => url, :html => {:class => "form-horizontal score_rule_form"} do |form| 
  if object.errors.any? 
 t("shared.form_errors") 
 object.errors.full_messages.each do |error_message| 
 error_message 
 end 
 end 
 
 end 
 

end

  end

  def update
    @score_rule.update_attributes(params[:score_rule])

    if @score_rule.valid?
      flash[:success] = t('flash.notice.model_updated', model: ScoreRule.model_name.human)
      redirect_to container_score_rules_path(@container)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("score_rules.edit") 
  form_for @score_rule, :url => url, :html => {:class => "form-horizontal score_rule_form"} do |form| 
  if object.errors.any? 
 t("shared.form_errors") 
 object.errors.full_messages.each do |error_message| 
 error_message 
 end 
 end 
 
 end 
 

end

    end
  end

  def destroy
    @score_rule.destroy
    flash[:success] = t('flash.notice.model_deleted', model: ScoreRule.model_name.human)

    # Note: a DELETE request redirect(302) will regenerate a new DELETE request to the new URL
    # Setting status to 302 is a walkaround
    #
    # Read more: http://softwareas.com/the-weirdness-of-ajax-redirects-some-workarounds
    redirect_to container_score_rules_path(@container), :status => 303
  end
end
