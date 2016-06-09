class SearchesController < ApplicationController

  MAX_SELECT_PEOPLE = 10
  MAX_SELECT_FAMILIES = 10

  before_filter :get_family, if: -> { params[:family_id] }

  def show
    create
  end

  def new
    redirect_to search_path
  end

  def create
    if params[:family_name].present? or params[:family_barcode_id].present?
      if params[:family_name] =~ /^\d+$/
        params[:family_barcode_id] = params.delete(:family_name)
      end
      @search = Search.new(params.merge(source: :family))
      @families = @search.results.page(params[:page])
    else
      @search = Search.new(params)
      @people = @search.results.page(params[:page])
    end
    respond_to do |format|
      format.html do
        if @people.length == 1 and (params[:name] or params[:quick_name])
          redirect_to person_path(id: @people.first)
        else
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if params[:select_person] 
  @people.each do |person| 
 label_tag do 
 if params[:select_one] 
 radio_button_tag 'ids[]', person.id, @people.length == 1 
 else 
 check_box_tag 'ids[]', person.id, @people.length == 1 
 end 
 person.name 
 end 
 end 
 if @more 
 t('search.results_not_shown') 
 end 
 if @people.empty? 
 t('search.people_found', count: 0) 
 end 
 if @people.length == 1 and !params[:no_auto_submit] 
 end 
 
 elsif params[:select_family] 
  @families.each do |family| 
 radio_button_tag 'id', family.id, @families.length == 1, id: "family#{family.id}", class: 'radiobutton' 
 label_tag "family#{family.id}", family.name, class: 'inline' 
 end 
 if @more 
 t('search.results_not_shown') 
 end 
 
 if @families.empty? 
 else 
 end 
 else 
 if @people 
  if @family 
 t('people.move.heading', family: @family.name) 
 t('people.move.description_html', family: @family.name, url: url_for(@family)) 
 end 
 t("search.people_found", count: @search.count) 
 if @logged_in.admin?(:view_hidden_profiles) and params[:show_hidden].nil? 
 t("search.not_showing_hidden_people") 
 end 
 pagination @people, params: params_without_action 
 if @people and @people.any? 
 if @logged_in.active? 
 if @search.business 
 t('search.column.business') 
 t('search.column.category') 
 else 
 t('search.column.name') 
 t('search.column.family') 
 end 
 if show_birthdays? 
 t('search.column.birthday') 
 end 
 if show_testimonies? 
 t('search.column.testimony') 
 end 
 if @family 
 end 
 @people.each do |person| 
 link_to person do 
 avatar_tag person, fallback_to_family: true 
 end 
 if @search.business 
 link_to person.business_name, person_path(person, business: true) 
 if person.business_category.present? 
 link_to person.business_category, search_path(business: true, category: person.business_category) 
 end 
 else 
 link_to person.name, person 
 unless person.visible? 
 end 
 if person.family 
 link_to person.family.name, person.family 
 else 
 t('search.no_family') 
 end 
 end 
 if show_birthdays? 
 if person.birthday 
 person.birthday.to_s(:date_without_year) 
 end 
 end 
 link_to_person_role(person, separator: "<span class='text-gray'> / </span>") 
 if show_testimonies? 
 truncate_words(person.testimony, length: 50) 
 link_to t('search.results.testimony_read_more'), testimony_person_path(person), class: 'btn btn-xs bg-gray' 
 end 
 if @family 
 unless @family.people.include?(person) 
 link_to family_person_path(@family, person, move_person: true), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-warning btn-xs' do 
 icon 'fa fa-arrow-circle-left' 
 t('people.move.button') 
 end 
 end 
 end 
 end 
 else 
 # limited access 
 @people.each do |person| 
 link_to person.name, person 
 end 
 end 
 end 
 pagination @people, params: params_without_action 
 
 elsif @families 
 escape_javascript render(partial: 'families_results') 
 end 
 end 

end

        end
      end
      format.js do
        if params[:auto_complete]
          @people = @people[0..MAX_SELECT_PEOPLE]
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @people.each do |person| 
 person.name 
 end 

end

        elsif params[:select_person]
          @more = @people.length > MAX_SELECT_PEOPLE
          @people = @people[0...MAX_SELECT_PEOPLE]
        elsif params[:select_family]
          @families ||= []
          @more = @families.length > MAX_SELECT_FAMILIES
          @families = @families.to_a[0..MAX_SELECT_FAMILIES]
        end
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if params[:select_person] 
  @people.each do |person| 
 label_tag do 
 if params[:select_one] 
 radio_button_tag 'ids[]', person.id, @people.length == 1 
 else 
 check_box_tag 'ids[]', person.id, @people.length == 1 
 end 
 person.name 
 end 
 end 
 if @more 
 t('search.results_not_shown') 
 end 
 if @people.empty? 
 t('search.people_found', count: 0) 
 end 
 if @people.length == 1 and !params[:no_auto_submit] 
 end 
 
 elsif params[:select_family] 
  @families.each do |family| 
 radio_button_tag 'id', family.id, @families.length == 1, id: "family#{family.id}", class: 'radiobutton' 
 label_tag "family#{family.id}", family.name, class: 'inline' 
 end 
 if @more 
 t('search.results_not_shown') 
 end 
 
 if @families.empty? 
 else 
 end 
 else 
 if @people 
  if @family 
 t('people.move.heading', family: @family.name) 
 t('people.move.description_html', family: @family.name, url: url_for(@family)) 
 end 
 t("search.people_found", count: @search.count) 
 if @logged_in.admin?(:view_hidden_profiles) and params[:show_hidden].nil? 
 t("search.not_showing_hidden_people") 
 end 
 pagination @people, params: params_without_action 
 if @people and @people.any? 
 if @logged_in.active? 
 if @search.business 
 t('search.column.business') 
 t('search.column.category') 
 else 
 t('search.column.name') 
 t('search.column.family') 
 end 
 if show_birthdays? 
 t('search.column.birthday') 
 end 
 if show_testimonies? 
 t('search.column.testimony') 
 end 
 if @family 
 end 
 @people.each do |person| 
 link_to person do 
 avatar_tag person, fallback_to_family: true 
 end 
 if @search.business 
 link_to person.business_name, person_path(person, business: true) 
 if person.business_category.present? 
 link_to person.business_category, search_path(business: true, category: person.business_category) 
 end 
 else 
 link_to person.name, person 
 unless person.visible? 
 end 
 if person.family 
 link_to person.family.name, person.family 
 else 
 t('search.no_family') 
 end 
 end 
 if show_birthdays? 
 if person.birthday 
 person.birthday.to_s(:date_without_year) 
 end 
 end 
 link_to_person_role(person, separator: "<span class='text-gray'> / </span>") 
 if show_testimonies? 
 truncate_words(person.testimony, length: 50) 
 link_to t('search.results.testimony_read_more'), testimony_person_path(person), class: 'btn btn-xs bg-gray' 
 end 
 if @family 
 unless @family.people.include?(person) 
 link_to family_person_path(@family, person, move_person: true), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-warning btn-xs' do 
 icon 'fa fa-arrow-circle-left' 
 t('people.move.button') 
 end 
 end 
 end 
 end 
 else 
 # limited access 
 @people.each do |person| 
 link_to person.name, person 
 end 
 end 
 end 
 pagination @people, params: params_without_action 
 
 elsif @families 
 escape_javascript render(partial: 'families_results') 
 end 
 end 

end

  end

  private

  def get_family
    @family = Family.find(params[:family_id])
    raise StandardError unless @logged_in.can_update?(@family)
  end

end
