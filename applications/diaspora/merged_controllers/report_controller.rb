#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ReportController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_moderator, except: [:create]

  def index
    @reports = Report.where(reviewed: false)
 content_for :head do 
 stylesheet_link_tag :admin 
 end 
 if current_user.admin? 
 render partial: "admins/admin_bar" 
 end 
 t("report.title") 
 @reports.each do |report| 
 if report.item 
 username = report.user.username 
 raw t("report.reported_label", person: link_to(username, user_profile_path(username))) 
 report_content(report) 
 t("report.reason_label", text: report.text) 
 button_to t("report.reported_user_details"), 
                  user_search_path(admins_controller_user_search: {guid: report.reported_author.guid}),
                  class: "btn pull-left btn-info btn-small", method: :post 
 button_to t("report.review_link"), report_path(report.id, type: report.item_type), 
                  class: "btn pull-left btn-info btn-small", method: :put 
 button_to t("report.delete_link"), report_path(report.id, type: report.item_type), 
                  data: {confirm: t("report.confirm_deletion")},
                  class: "btn pull-right btn-danger btn-small", method: :delete 
 else 
 username = report.user.username 
 raw t("report.reported_label", person: link_to(username, user_profile_path(username))) 
 report_content(report) 
 button_to t("report.review_link"), report_path(report.id, type: report.item_type), 
                  class: "btn pull-left btn-info btn-small", method: :put 
 end 
 end 

  end

  def update
    if report = Report.where(id: params[:id]).first
      report.mark_as_reviewed
    end
    redirect_to :action => :index
  end

  def destroy
    if (report = Report.where(id: params[:id]).first) && report.destroy_reported_item
      flash[:notice] = I18n.t "report.status.destroyed"
    else
      flash[:error] = I18n.t "report.status.failed"
    end
    redirect_to action: :index
  end

  def create
    report = current_user.reports.new(report_params)
    if report.save
      render json: true, status: 200
    else
      render nothing: true, status: 409
    end
  end

  private
    def report_params
      params.require(:report).permit(:item_id, :item_type, :text)
    end
end
