class Administration::AttendanceController < ApplicationController

  before_filter :only_admins

  VALID_SORT_COLS = %w(
    attendance_records.last_name
    attendance_records.first_name
    groups.name
    attendance_records.attended_at
    attendance_records.created_at
    people.child
  )

  # TODO refactor
  def index
    @attended_at = params[:attended_at] ? Date.parse_in_locale(params[:attended_at]) : Date.today
    @groups = AttendanceRecord.groups_for_date(@attended_at)
    @rel = AttendanceRecord.where("attended_at >= ? and attended_at <= ?", @attended_at.strftime('%Y-%m-%d 0:00'), @attended_at.strftime('%Y-%m-%d 23:59:59'))
    @rel.includes!(:person, :group)
    @rel.references!(:person, :group)
    if params[:group_id].to_i > 0
      @group = Group.find(params[:group_id])
      @rel.where!(group_id: @group.id)
      params[:sort] ||= 'attendance_records.last_name,attendance_records.first_name'
    end
    if params[:person_name]
      @rel.where!("concat(attendance_records.first_name, ' ', attendance_records.last_name) like ?", "%#{params[:person_name]}%")
    end
    unless params[:sort].to_s.split(',').all? { |col| VALID_SORT_COLS.include?(col) }
      params[:sort] = 'groups.name'
    end
    @rel.order!(params[:sort])
    respond_to do |format|
      format.html do
        @records = @rel.paginate(page: params[:page], per_page: 100)
        @record_count = @records.total_entries
      end
      format.csv do
        CSV.generate(csv_str = '') do |csv|
          csv << %w(group_name group_id group_link_code first_name last_name person_id person_legacy_id class_time recorded_time)
          @rel.each do |record|
            csv << [
              record.group.try(:name),
              record.group.try(:id),
              record.group.try(:link_code),
              record.first_name,
              record.last_name,
              record.person_id,
              record.person.try(:legacy_id),
              record.attended_at.to_s,
              record.created_at.to_s
            ]
          end
        end
        render text: csv_str
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @group 
 @title = t('attendance.heading_html', group: link_to(@group.name, @group), when: @attended_at.to_s(:date)) 
 else 
 @title = t('attendance.heading_without_group', when: @attended_at.to_s(:date)) 
 end 
 content_for :header do 
 breadcrumbs 
 link_to prev_administration_attendance_index_path(attended_at: @attended_at) do 
 icon 'fa fa-arrow-circle-o-left' 
 end 
 @title 
 link_to next_administration_attendance_index_path(attended_at: @attended_at) do 
 icon 'fa fa-arrow-circle-o-right' 
 end 
 end 
 t('attendance.records', count: @record_count) 
 if @records.any? 
 pagination @records 
 sortable_column_heading t('attendance.name'),          'attendance_records.last_name,attendance_records.first_name', %w(attended_at group_id) 
 sortable_column_heading t('attendance.adult'),         'people.child',                                               %w(attended_at group_id) 
 sortable_column_heading t('attendance.group'),         'groups.name',                                                %w(attended_at group_id) 
 sortable_column_heading t('attendance.class_time'),    'attendance_records.attended_at',                             %w(attended_at group_id) 
 sortable_column_heading t('attendance.recorded_time'), 'attendance_records.created_at',                              %w(attended_at group_id) 
 t('attendance.can_pickup_people') 
 t('attendance.cannot_pickup_people') 
 @records.each do |record| 
 if record.first_name.present? 
 if record.person 
 link_to " ", record.person 
 else 
 record.first_name 
 record.last_name 
 end 
 elsif record.person 
 link_to record.person.name, record.person 
 else 
 t('attendance.name_unknown') 
 end 
 if record.person && record.person.adult? 
 t('attendance.adult') 
 end 
 if record.group 
 link_to record.group.name, record.group 
 else 
 t('attendance.group_missing') 
 end 
 record.attended_at.to_s(:time) 
 record.created_at.to_s(:time) 
 record.all_pickup_people.join(', ') 
 record.cannot_pick_up 
 link_to administration_attendance_path(record), data: { remote: true, method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-delete btn-xs' do 
 icon 'fa fa-trash-o' 
 end 
 if record.medical_notes.present? 
 t('attendance.medical_notes') 
 record.medical_notes 
 end 
 end 
 pagination @records 
 else 
 t('attendance.no_records') 
 end 
 form_tag administration_attendance_index_path, method: :get do 
 label_tag :attended_at, t('attendance.date') 
 date_field_tag :attended_at, @attended_at.to_s(:date), class: 'form-control', onchange: 'this.form.submit()' 
 if @groups.any? 
 label_tag :group_id, t('attendance.group') 
 select_tag :group_id, options_for_select(['']) + options_from_collection_for_select(@groups, :id, :name, params[:group_id].to_i), onchange: 'this.form.submit()', class: 'form-control' 
 label_tag :person_name, t('attendance.search_person') 
 text_field_tag :person_name, params[:person_name], class: 'form-control' 
 if params[:person_name] 
 link_to administration_attendance_index_path(attended_at: @attended_at, group_id: params[:group_id]), class: 'btn btn-danger' do 
 icon 'fa fa-times-circle' 
 end 
 end 
 button_tag class: 'btn btn-info' do 
 icon 'fa fa-search' 
 end 
 end 
 end 
 if @records.any? 
 link_to administration_attendance_index_path(format: 'csv', attended_at: @attended_at, group_id: params[:group_id], person_name: params[:person_name]), class: 'btn btn-info' do 
 icon 'fa fa-download' 
 t('attendance.export') 
 end 
 end 

end

  end

  def prev
    @attended_at = Date.parse(params[:attended_at])
    date = AttendanceRecord.where("attended_at < ?", @attended_at.strftime('%Y/%m/%d 0:00')).maximum(:attended_at)
    redirect_to administration_attendance_index_path(attended_at: date)
  end

  def next
    @attended_at = Date.parse(params[:attended_at])
    date = AttendanceRecord.where("attended_at > ?", @attended_at.strftime('%Y/%m/%d 23:59:59')).minimum(:attended_at)
    redirect_to administration_attendance_index_path(attended_at: date)
  end

  def destroy
    @record = AttendanceRecord.find(params[:id])
    @record.destroy
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @record.id 

end

  end

  private

    def only_admins
      unless @logged_in.admin?(:manage_attendance)
        render text: t('only_admins'), layout: true, status: 401
        return false
      end
    end

end
