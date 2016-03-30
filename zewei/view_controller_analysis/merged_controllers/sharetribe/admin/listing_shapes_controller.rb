class Admin::ListingShapesController < ApplicationController
  before_filter :ensure_is_admin

  before_filter :ensure_no_braintree_or_checkout
  before_filter :set_url_name

  LISTING_SHAPES_NAVI_LINK = "listing_shapes"

  Shape = ListingShapeDataTypes::Shape

  def index
    category_count = @current_community.categories.count
    template_label_key_list = ListingShapeTemplates.new(process_summary).label_key_list

    render("index",
           locals: {
             selected_left_navi_link: LISTING_SHAPES_NAVI_LINK,
             templates: template_label_key_list,
             display_knowledge_base_articles: APP_CONFIG.display_knowledge_base_articles,
             knowledge_base_url: APP_CONFIG.knowledge_base_url,
             category_count: category_count,
             listing_shapes: all_shapes(community_id: @current_community.id, include_categories: true)})
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.listing_shapes.index.listing_shapes") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.listing_shapes.index.listing_shapes") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 content_for :javascript do 
 end 
  grouped_links = links.group_by {|l| l[:topic]} 
  APP_CONFIG.uservoice_widget_url 
 @current_user.confirmed_notification_email_to 
 @current_user.full_name 
 @current_user.id 
 @current_user.created_at.to_time.to_i
 @current_community.id 
 @current_community.full_url 
 @current_community.created_at.to_time.to_i 
 @current_plan[:plan_level] 
 ( @current_community.created_at < 10.days.ago ? "UserVoice.push(['autoprompt', {}]);".html_safe : "//no autoprompt yet for this site") 
 
 sel_link = (local_assigns.has_key? :selected_left_navi_link) ? selected_left_navi_link : @selected_left_navi_link 
 t("admin.left_hand_navigation.general") 
 grouped_links[:general].each do |link| 
 link[:data_uv_trigger] 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.users_and_transactions") 
 grouped_links[:manage].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.configure") 
 grouped_links[:configure].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 links.each do |link| 
 if link[:name].eql?(sel_link) 
 link[:icon_class] 
 link[:text] 
 end 
 end 
 links.each do |link| 
 link[:icon_class] 
 link[:text] 
 end 
 
 t(".listing_shapes") 
 t(".description") 
 if display_knowledge_base_articles 
 link_to t(".read_more_about_order_types"), "#{knowledge_base_url}/articles/614718" 
 end 
 t(".header.listing_shape_name") 
 t(".header.listing_shape_categories") 
 sort_disabled_class = listing_shapes.size == 1 ? "disabled" : "" 
 listing_shapes.map do |shape| 
 t(shape[:name_tr_key]) 
 if shape[:category_ids].size == 0 
 t("admin.listing_shapes.index.no_categories") 
 elsif shape[:category_ids].size == category_count 
 t("admin.listing_shapes.index.all_categories") 
 else 
 t("admin.listing_shapes.index.category_count", :category_count => "#{shape[:category_ids].size}/#{category_count}") 
 end 
 link_to edit_admin_listing_shape_path(shape[:name]) do 
 icon_tag("edit", ["icon-fix"]) 
 end 
 link_to '#', :class => "js-listing-shape-action-up admin-sort-button #{sort_disabled_class}", :tabindex => "-1" do 
 icon_tag("directup", ["icon-fix"]) 
 end 
 link_to '#', :class => "js-listing-shape-action-down admin-sort-button #{sort_disabled_class}", :tabindex => "-1" do 
 icon_tag("directdown", ["icon-fix"]) 
 end 
 end 
 icon_class("loading") 
 t("admin.listing_shapes.index.order.saving_order") 
 icon_class("check") 
 t("admin.listing_shapes.index.order.save_order_successful") 
 t("admin.listing_shapes.index.order.save_order_error") 
 form_tag new_admin_listing_shape_path, method: :get do 
 t("admin.listing_shapes.index.add_new_shape") 
 select_tag :template, options_for_select([[t("admin.listing_shapes.index.select_template"), nil]].concat(templates.map { |(label_tr_key, template_name)| [t(label_tr_key), template_name]})), onChange: "form.submit();" 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def new
    template = ListingShapeTemplates.new(process_summary).find(params[:template], available_locales.map(&:second))

    unless template
      return redirect_to action: :index
    end

    render_new_form(template, process_summary, available_locales())
  end

  def edit
    shape = ShapeService.new(processes).get(
      community_id: @current_community.id,
      name: params[:url_name],
      locales: available_locales.map { |_, locale| locale }
    ).data

    return redirect_to error_not_found_path if shape.nil?

    render_edit_form(params[:url_name], shape, process_summary, available_locales())
  end

  def create
    shape = filter_uneditable_fields(FormViewLayer.params_to_shape(params), process_summary)

    create_result = validate_shape(shape).and_then { |shape|
      ShapeService.new(processes).create(
        community_id: @current_community.id,
        default_locale: @current_community.default_locale,
        opts: shape
      )
    }

    if create_result.success
      flash[:notice] = t("admin.listing_shapes.new.create_success", shape: pick_translation(shape[:name]))
      redirect_to action: :index
    else
      flash.now[:error] = t("admin.listing_shapes.new.create_failure", error_msg: create_result.error_msg)
      render_new_form(shape, process_summary, available_locales())
    end

  end

  def update
    shape = filter_uneditable_fields(FormViewLayer.params_to_shape(params), process_summary)

    update_result = validate_shape(shape).and_then { |shape|
      ShapeService.new(processes).update(
        community_id: @current_community.id,
        name: params[:url_name],
        opts: shape
      )
    }

    if update_result.success
      flash[:notice] = t("admin.listing_shapes.edit.update_success", shape: pick_translation(shape[:name]))
      return redirect_to admin_listing_shapes_path
    else
      flash.now[:error] = t("admin.listing_shapes.edit.update_failure", error_msg: update_result.error_msg)
      return render_edit_form(params[:url_name], shape, process_summary, available_locales())
    end
  end

  def order
    ordered_ids = params[:order].map(&:to_i)

    shapes = all_shapes(community_id: @current_community.id, include_categories: false)

    old_shape_order_id_map = shapes.map { |s|
      {
        id: s[:id],
        sort_priority: s[:sort_priority]
      }
    }

    old_shape_order = old_shape_order_id_map.map { |s| s[:sort_priority] }

    distinguisable_order = old_shape_order.reduce([old_shape_order.first]) { |memo, x|
      last = memo.last
      if x <= last
        memo << last + 1
      else
        memo << x
      end
    }

    new_shape_order_id_map = ordered_ids.zip(distinguisable_order).map { |id, sort|
      {
        id: id,
        sort_priority: sort
      }
    }

    diff = ArrayUtils.diff_by_key(old_shape_order_id_map, new_shape_order_id_map, :id)

    diff.select { |d| d[:action] == :changed }.each { |d|
      opts = { sort_priority: d[:value][:sort_priority]}
      listing_api.shapes.update(community_id: @current_community.id, listing_shape_id: d[:value][:id], opts: opts)
    }

    render nothing: true, status: 200
  end

  def close_listings
    listing_api.shapes.get(community_id: @current_community.id, name: params[:url_name]).and_then { |shape|
      listing_api.listings.update_all(community_id: @current_community.id, query: { listing_shape_id: shape[:id] }, opts: { open: false })
    }.on_success {
      flash[:notice] = t("admin.listing_shapes.successfully_closed")
      return redirect_to action: :edit, id: params[:url_name]
    }.on_error {
      flash[:error] = t("admin.listing_shapes.can_not_find_name", name: params[:url_name])
      return redirect_to action: :index
    }
  end

  def destroy
    can_delete_shape?(params[:url_name], all_shapes(community_id: @current_community.id, include_categories: true)).and_then { |s|
      listing_api.listings.update_all(community_id: @current_community.id, query: { listing_shape_id: s[:id] }, opts: { open: false, listing_shape_id: nil })
    }.and_then {
      listing_api.shapes.delete(
        community_id: @current_community.id,
        name: params[:url_name]
      )
    }.on_success { |deleted_shape|
      flash[:notice] = t("admin.listing_shapes.successfully_deleted", order_type: t(deleted_shape[:name_tr_key]))
    }.on_error { |error_msg|
      flash[:error] = "Cannot delete order type, error: #{error_msg}"
    }

    redirect_to action: :index
  end

  private

  def filter_uneditable_fields(shape, process_summary)
    uneditable_keys = uneditable_fields(process_summary, shape[:author_is_seller]).select { |_, uneditable| uneditable }.keys
    shape.except(*uneditable_keys)
  end

  def uneditable_fields(process_summary, author_is_seller)
    {
      shipping_enabled: !process_summary[:preauthorize_available] || !author_is_seller,
      online_payments: !process_summary[:preauthorize_available] || !author_is_seller,
    }
  end

  def render_new_form(form, process_summary, available_locs)
    locals = common_locals(form, 0, process_summary, available_locs)
    render("new", locals: locals)
  end

  def render_edit_form(url_name, form, process_summary, available_locs)
    can_delete_res = can_delete_shape?(url_name, all_shapes(community_id: @current_community.id, include_categories: true))
    cant_delete = !can_delete_res.success
    cant_delete_reason = cant_delete ? can_delete_res.error_msg : nil

    count = listing_api.listings.count(
      community_id: @current_community.id,
      query: {
        listing_shape_id: form[:id],
        open: true
      }).data

    locals = common_locals(form, count, process_summary, available_locs).merge(
      url_name: url_name,
      name: pick_translation(form[:name]),
      cant_delete: cant_delete,
      cant_delete_reason: cant_delete_reason
    )
    render("edit", locals: locals)
  end

  def common_locals(form, count, process_summary, available_locs)
    { selected_left_navi_link: LISTING_SHAPES_NAVI_LINK,
      uneditable_fields: uneditable_fields(process_summary, form[:author_is_seller]),
      shape: FormViewLayer.shape_to_locals(form),
      count: count,
      locale_name_mapping: available_locs.map { |name, l| [l, name] }.to_h
    }
  end

  def can_delete_shape?(current_shape_name, shapes)
    listing_shapes_categories_map = shapes.map { |shape|
      [shape[:name], shape[:category_ids]]
    }

    categories_listing_shapes_map = HashUtils.transpose(listing_shapes_categories_map)

    last_in_category_ids = categories_listing_shapes_map.select { |category_id, shape_names|
      shape_names.size == 1 && shape_names.include?(current_shape_name)
    }.keys

    shape = shapes.find { |s| s[:name] == current_shape_name }

    if !shape
      Result::Error.new(t("admin.listing_shapes.can_not_find_name", name: current_shape_name))
    elsif shapes.length == 1
      Result::Error.new(t("admin.listing_shapes.edit.can_not_delete_last"))
    elsif !last_in_category_ids.empty?
      categories = ListingService::API::Api.categories.get_all(community_id: @current_community).data
      category_names = pick_category_names(categories, last_in_category_ids, I18n.locale)

      Result::Error.new(t("admin.listing_shapes.edit.can_not_delete_only_one_in_categories", categories: category_names.join(", ")))
    else
      Result::Success.new(shape)
    end
  end

  def pick_category_names(categories, ids, locale)
    locale = locale.to_s

    pick_categories(categories, ids)
      .map { |c| Maybe(c[:translations].find { |t| t[:locale] == locale }).or_else(c[:translations].first) }
      .map { |t| t[:name] }
  end

  def pick_categories(category_tree, ids)
    category_tree.reduce([]) { |acc, category|
      if ids.include?(category[:id])
        acc << category
      end

      if category[:children].present?
        acc.concat(pick_categories(category[:children], ids))
      end

      acc
    }
  end

  def listing_api
    ListingService::API::Api
  end

  def all_shapes(community_id:, include_categories:)
    listing_api.shapes.get(community_id: community_id, include_categories: include_categories)
      .maybe()
      .or_else([])
  end

  def process_summary
    @process_summary ||= processes.reduce({}) { |info, process|
      info[:preauthorize_available] = true if process[:process] == :preauthorize
      info[:request_available] = true if process[:author_is_seller] == false
      info
    }
  end

  def processes
    @processes ||= TransactionService::API::Api.processes.get(community_id: @current_community.id)[:data]
  end

  def validate_shape(form)
    form = Shape.call(form)

    errors = []

    if form[:shipping_enabled] && !form[:online_payments]
      errors << "Shipping cannot be enabled without online payments"
    end

    if form[:online_payments] && !form[:price_enabled]
      errors << "Online payments cannot be enabled without price"
    end

    if (form[:units].present? || form[:custom_units].present?) && !form[:price_enabled]
      errors << "Price units cannot be used without price field"
    end

    if errors.empty?
      Result::Success.new(form)
    else
      Result::Error.new(errors.join(", "))
    end
  end

  def pick_translation(translations)
    translations.find { |(locale, translation)|
      locale.to_s == I18n.locale.to_s
    }.second
  end

  def ensure_no_braintree_or_checkout
    gw = PaymentGateway.where(community_id: @current_community.id).first
    if !@current_user.is_admin? && gw
      flash[:error] = "Not available for your payment gateway: #{gw.type}"
      redirect_to edit_details_admin_community_path(@current_community.id)
    end
  end

  # FormViewLayer provides helper functions to transform:
  # - Shape hash to renderable format
  # - params from form back to Shape
  #
  module FormViewLayer
    module_function

    def params_to_shape(params)
      form_params = HashUtils.symbolize_keys(params)

      units = parse_predefined_units(form_params[:units])
        .concat(parse_existing_custom_units(Maybe(form_params)[:custom_units][:existing].or_else([])))
        .concat(parse_new_custom_units(Maybe(form_params)[:custom_units][:new].or_else([])))

      parsed_params = form_params.merge(
        units: units,
        author_is_seller: form_params[:author_is_seller] == "false" ? false : true # default true
      )

      Shape.call(parsed_params)
    end

    def shape_to_locals(shape)
      shape = Shape.call(shape)

      shape.merge(
        predefined_units: expand_predefined_units(shape[:units]),
        custom_units: encode_custom_units(shape[:units].select { |unit| unit[:type] == :custom })
      )
    end

    # private

    def expand_predefined_units(shape_units)
      shape_units_set = shape_units.map { |t| t[:type] }.to_set

      ListingShapeHelper.predefined_unit_types
        .map { |t| {type: t, enabled: shape_units_set.include?(t), label: I18n.t("admin.listing_shapes.units.#{t}")} }
    end

    def encode_custom_units(custom_units)
      custom_units.map { |u|
        {
          name: u[:name],
          value: ListingShapeDataTypes::Unit.serialize(u)
        }
      }
    end

    def parse_predefined_units(selected_units)
      (selected_units || []).map { |type, _| {type: type.to_sym, enabled: true}}
    end

    def parse_existing_custom_units(existing_units)
      existing_units.map { |_, unit|
        ListingShapeDataTypes::Unit.deserialize(unit)
          .merge({type: :custom, enabled: true})
      }
    end

    def parse_new_custom_units(new_units)
      new_units.map(&:second).map { |u|
        u.merge(type: :custom, enabled: true)
          .except(:name_tr_key, :selector_tr_key)
      }
    end
  end

  # The shape name is used as 'id'
  def set_url_name
    params[:url_name] = params[:id]
    params.delete :id
  end
end
