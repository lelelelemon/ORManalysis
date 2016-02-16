class ModeratorsController < BaseController
  before_action :admin_required

  def create
    @forum = Forum.find(params[:forum_id])
    @user = User.find(params[:user_id])
    @moderatorship = Moderatorship.create!(:forum => @forum, :user => @user)
    respond_to do |format|
      format.js
    end

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @moderatorship.valid? 
  if !user.moderator_of?(forum) 
 link_to :make_moderator.l, forum_moderators_path(:forum_id => forum.id, :user_id => user.id), :method => :post, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 else 
 moderatorship = Moderatorship.find_by_user_id_and_forum_id(user.id, forum.id) 
 link_to :remove_moderator.l, forum_moderator_path(forum, moderatorship.id), :method => :delete, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 end 
 
 else 
 :failed.l 
 end 

end

  end

  def destroy
    @moderatorship = Moderatorship.find(params[:id])
    @moderatorship.destroy
    respond_to do |format|
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  if !user.moderator_of?(forum) 
 link_to :make_moderator.l, forum_moderators_path(:forum_id => forum.id, :user_id => user.id), :method => :post, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 else 
 moderatorship = Moderatorship.find_by_user_id_and_forum_id(user.id, forum.id) 
 link_to :remove_moderator.l, forum_moderator_path(forum, moderatorship.id), :method => :delete, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 end 
 

end

  end


end
