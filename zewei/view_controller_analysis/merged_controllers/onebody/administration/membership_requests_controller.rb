class Administration::MembershipRequestsController < ApplicationController
  before_filter :only_admins

  def index
    @reqs_by_group = MembershipRequest.all.to_a.group_by(&:group)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('admin.group_membership_requests') 
 if @reqs_by_group.any? 
 @reqs_by_group.each do |group, reqs| 
 avatar_tag(group) 
 group ? link_to(group.name, group) : '(' + t('groups.deleted') + ')' 
 link_to t('admin.membership_requests.count', count: reqs.length), group_memberships_path(group), class: 'btn btn-info' 
 end 
 else 
 t('none') 
 end 

end

  end

  private

    def only_admins
      unless @logged_in.admin?(:manage_groups)
        render text: t('only_admins'), layout: true, status: 401
        return false
      end
    end

end
