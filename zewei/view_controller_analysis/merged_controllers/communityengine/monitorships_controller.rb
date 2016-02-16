class MonitorshipsController < BaseController
  before_action :login_required

  def create
    @monitorship = Monitorship.find_or_initialize_by(:user_id => current_user.id, :topic_id => params[:topic_id])
    @monitorship.update_attribute :active, true
    respond_to do |format| 
      format.html { redirect_to forum_topic_path(params[:forum_id], params[:topic_id]) }
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 :watching_topic.l 

end

  end
  
  def destroy
    Monitorship.where('user_id = ? and topic_id = ?', current_user.id, params[:topic_id]).update_all(['active = ?', false])
    respond_to do |format| 
      format.html { redirect_to forum_topic_path(params[:forum_id], params[:topic_id]) }
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 :watch_topic.l 

end

  end
end
