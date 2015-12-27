class Admin::NotesController < Admin::BaseController
  layout 'administration'
  cache_sweeper :blog_sweeper

  before_action :load_existing_notes, only: [:index, :edit]
  before_action :find_note, only: [:edit, :update, :show, :destroy]

  def index
    @note = Publisher.new(current_user).new_note
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 content_for :page_heading do 
 t(".notes") 
 end 

end
 
 form_for @note, url: admin_notes_path do |n| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 n.hidden_field :text_filter, value: current_user.text_filter_name 
 n.text_area :body, {class: 'form-control', rows: '7', placeholder: t(".compose_new_note")} 
 t(".publish_settings") 
 unless twitter_available?(this_blog, current_user) 
 t(".how_to_setup_twitter", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 else 
 check_box_tag 'push_to_twitter', true, true 
 t(".posse_to_twitter")
 t(".in_reply_to") 
 n.text_field :in_reply_to_status_id, class: 'form-control', placeholder: t(".tweet_id_like") 
 end 
 t(".permanent_link") 
 n.text_field :permalink, class: 'form-control' 
 t(".publish_at") 
 n.text_field :published_at, {class: 'form-control datepicker', placeholder: t('.now')} 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".publish"), class: 'btn btn-success') 

end
 
 end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 if @notes.empty? 
 t("admin.notes.form.no_notes") 
 end 
 render @notes 
 display_pagination(@notes, 3, 'first', 'last')

end
 

  end

  def show
    unless @note.access_by?(current_user)
      flash[:error] = I18n.t('admin.base.not_allowed')
      redirect_to admin_notes_url
    end
 content_for :page_heading do 
 t('.destroy_confirmation') 
 end 
 t(".are_you_sure", note: @note)
 form_for @note, url: admin_note_path(@note), method: :delete do 
 t(".action_or_other", first_action: link_to(t(".cancel"), {action: 'index'}), second_action: submit_tag(t(".delete"), class: "btn btn-danger")) 
 end 

  end

  def edit
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 content_for :page_heading do 
 t(".notes") 
 end 

end
 
 form_for @note, url: admin_note_path(@note) do |n| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 n.hidden_field :text_filter, value: current_user.text_filter_name 
 n.text_area :body, {class: 'form-control', rows: '7', placeholder: t(".compose_new_note")} 
 t(".publish_settings") 
 unless twitter_available?(this_blog, current_user) 
 t(".how_to_setup_twitter", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 else 
 check_box_tag 'push_to_twitter', true, true 
 t(".posse_to_twitter")
 t(".in_reply_to") 
 n.text_field :in_reply_to_status_id, class: 'form-control', placeholder: t(".tweet_id_like") 
 end 
 t(".permanent_link") 
 n.text_field :permalink, class: 'form-control' 
 t(".publish_at") 
 n.text_field :published_at, {class: 'form-control datepicker', placeholder: t('.now')} 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".publish"), class: 'btn btn-success') 

end
 
 end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 if @notes.empty? 
 t("admin.notes.form.no_notes") 
 end 
 render @notes 
 display_pagination(@notes, 3, 'first', 'last')

end
 

  end

  def create
    note = Publisher.new(current_user).new_note

    note.published = true
    note.published_at = parse_date_time params[:note][:published_at]
    note.attributes = params[:note].permit!
    note.text_filter ||= current_user.default_text_filter
    note.published_at ||= Time.now
    if note.save
      if params[:push_to_twitter] && note.twitter_id.blank?
        unless note.send_to_twitter
          flash[:error] = I18n.t('errors.problem_sending_to_twitter')
          flash[:error] += " : #{note.errors.full_messages.join(' ')}"
        end
      end
      flash[:notice] = I18n.t('notice.note_successfully_created')
    else
      flash[:error] = note.errors.full_messages
    end
    redirect_to admin_notes_url
  end

  def update
    @note.attributes = params[:note].permit!
    @note.save
    redirect_to admin_notes_url
  end

  def destroy
    @note.destroy
    flash[:notice] = I18n.t('admin.base.successfully_deleted', name: 'note')
    redirect_to admin_notes_url
  end

  private

  def load_existing_notes
    @notes = Note.page(params[:page]).per(this_blog.limit_article_display)
  end

  def find_note
    @note = Note.find(params[:id])
  end
end
