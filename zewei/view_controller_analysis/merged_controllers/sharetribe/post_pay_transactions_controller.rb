class PostPayTransactionsController < ApplicationController

  before_filter do |controller|
   controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_do_a_transaction")
  end

  before_filter :fetch_listing_from_params
  before_filter :ensure_listing_is_open
  before_filter :ensure_listing_author_is_not_current_user
  before_filter :ensure_authorized_to_reply
  before_filter :ensure_can_receive_payment, only: [:preauthorize, :preauthorized]

  ContactForm = FormUtils.define_form("ListingConversation", :content, :sender_id, :listing_id, :community_id)
    .with_validations { validates_presence_of :content, :listing_id }

  def new
    @listing_conversation = new_contact_form

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 action_button_label(listing) 
 link_to(listing.title, listing) 
 end 
  Maybe(listing).map do |listing| 
 price = Maybe(listing).price.or_else(nil) 
 sum = Maybe(transaction).payment.total_sum.or_else(nil) 
 Maybe(transaction).booking.each do |booking| 
 l booking.start_on, format: :long_with_abbr_day_name 
 "-" 
 l booking.end_on, format: :long_with_abbr_day_name 
 "(#{pluralize(booking.duration, t(".day"), t(".days"))})" 
 t(".price_per_day", price: humanized_money_with_symbol(listing.price)) 
 end 
 if sum 
 t("conversations.show.sum", sum: humanized_money_with_symbol(sum)) 
 elsif price 
 t("conversations.show.price", price: humanized_money_with_symbol(listing.price)) 
 if listing.quantity.present? 
 "/ #{listing.quantity}" 
 elsif listing.unit_type.present? 
 "/ #{ListingViewUtils.translate_unit(listing.unit_type, listing.unit_tr_key)}" 
 end 
 if @current_community.vat 
 t("conversations.show.price_excludes_vat") 
 end 
 end 
 end 
 
 form_for contact_form, :url => contact_to_listing do |form| 
 form.label :content, t("conversations.new.message_to", author_name: link_to(listing.author.name(@current_community), listing.author)).html_safe 
 form.text_area :content, :class => "text_area" 
 form.hidden_field :sender_id, :value => @current_user.id 
 form.hidden_field :listing_id, :value => @listing.id 
 form.hidden_field :community_id, :value => @current_community.id 
 form.button action_button_label(listing), :class => "send_button" 
 end 

end

  end

  def create
    contact_form = new_contact_form(params[:listing_conversation])

    if contact_form.valid?
      transaction_response = TransactionService::Transaction.create({
          transaction: {
            community_id: @current_community.id,
            listing_id: @listing.id,
            listing_title: @listing.title,
            starter_id: @current_user.id,
            listing_author_id: @listing.author.id,
            unit_type: @listing.unit_type,
            unit_price: @listing.price,
            unit_tr_key: @listing.unit_tr_key,
            listing_quantity: 1,
            content: contact_form.content,
            payment_gateway: @current_community.payment_gateway.gateway_type,
            payment_process: :postpay,
          }
        })

      unless transaction_response[:success]
        flash[:error] = "Sending the message failed. Please try again."
        return redirect_to root
      end

      transaction_id = transaction_response[:data][:transaction][:id]

      flash[:notice] = t("layouts.notifications.message_sent")
      Delayed::Job.enqueue(TransactionCreatedJob.new(transaction_id, @current_community.id))

      [3, 10].each do |send_interval|
        Delayed::Job.enqueue(
          AcceptReminderJob.new(
            transaction_id,
            @listing.author.id, @current_community.id),
          :priority => 9, :run_at => send_interval.days.from_now)
      end

      redirect_to session[:return_to_content] || root
    else
      flash[:error] = "Sending the message failed. Please try again."
      redirect_to root
    end
  end

  private

  def ensure_listing_author_is_not_current_user
    if @listing.author == @current_user
      flash[:error] = t("layouts.notifications.you_cannot_send_message_to_yourself")
      redirect_to (session[:return_to_content] || root)
    end
  end

  # Ensure that only users with appropriate visibility settings can reply to the listing
  def ensure_authorized_to_reply
    unless @listing.visible_to?(@current_user, @current_community)
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
      redirect_to root and return
    end
  end

  def ensure_listing_is_open
    if @listing.closed?
      flash[:error] = t("layouts.notifications.you_cannot_reply_to_a_closed_offer")
      redirect_to (session[:return_to_content] || root)
    end
  end

  def fetch_listing_from_params
    @listing = Listing.find(params[:listing_id] || params[:id])
  end

  def new_contact_form(conversation_params = {})
    ContactForm.new(conversation_params.merge({sender_id: @current_user.id, listing_id: @listing.id, community_id: @current_community.id}))
  end

  def ensure_can_receive_payment
    Maybe(@current_community).payment_gateway.each do |gateway|
      unless gateway.can_receive_payments?(@listing.author)
        flash[:error] = t("layouts.notifications.listing_author_payment_details_missing")
        redirect_to (session[:return_to_content] || root)
      end
    end
  end
end
