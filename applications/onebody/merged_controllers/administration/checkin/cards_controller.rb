class Administration::Checkin::CardsController < ApplicationController

  before_filter :only_admins
  
  VALID_SORT_COLS = ['id', 'legacy_id', 'last_name,name', 'barcode_id', 'barcode_assigned_at desc']
  
  def index
    respond_to do |format|
      scope = Family.where("barcode_id is not null and barcode_id != '' and deleted = ?", false)
      format.html do
        params[:sort] = 'barcode_assigned_at desc' unless VALID_SORT_COLS.include?(params[:sort])
        @families = scope.order(params[:sort]).paginate(per_page: 100, page: params[:page])
      end
      format.csv do
        @families = scope.select('id, legacy_id, name, last_name, barcode_id, barcode_assigned_at')
                         .order('barcode_assigned_at desc')
        out = CSV.generate do |csv|
          @families.each do |family|
            csv << [family.id, family.legacy_id, family.name, family.barcode_id, family.barcode_assigned_at]
          end
        end
        render text: out
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.cards.heading') 
 pagination @families 
 link_to t('checkin.cards.table.id'),          administration_checkin_cards_path(sort: 'id') 
 link_to t('checkin.cards.table.legacy_id'),   administration_checkin_cards_path(sort: 'legacy_id') 
 link_to t('checkin.cards.table.family'),      administration_checkin_cards_path(sort: 'last_name,name') 
 link_to t('checkin.cards.table.barcode'),     administration_checkin_cards_path(sort: 'barcode_id') 
 link_to t('checkin.cards.table.assigned_at'), administration_checkin_cards_path(sort: 'barcode_assigned_at desc') 
 @families.each do |family| 
 family.id 
 family.legacy_id 
 link_to family.name, family 
 family.barcode_id 
 family.barcode_assigned_at.to_s 
 end 
 pagination @families 
 if @families.any? 
 link_to administration_checkin_cards_path(format: 'csv'), class: 'btn btn-info' do 
 icon 'fa fa-download' 
 t('checkin.cards.export.button') 
 end 
 else 
 t('checkin.cards.none') 
 end 

end

  end
  
  private
  
    def only_admins
      unless @logged_in.admin?(:manage_checkin)
        render :text => 'You must be an administrator to use this section.', :layout => true, :status => 401
        return false
      end
    end
  
    def feature_enabled?
      unless Setting.get(:features, :checkin)
        render :text => 'This feature is unavailable.', :layout => true
        false
      end
    end
  
end
