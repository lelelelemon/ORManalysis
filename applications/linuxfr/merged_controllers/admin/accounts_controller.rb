# encoding: UTF-8
class Admin::AccountsController < AdminController
  before_action :load_account, except: [:index]

  def index
    accounts = Account
    if params[:login].present?
      @login = params[:login]
      accounts = accounts.where("login LIKE ? COLLATE UTF8_GENERAL_CI", "#{@login}%")
    end
    if params[:date].present?
      @date = params[:date]
      accounts = accounts.where("created_at LIKE ?", "#{@date}%")
    end
    @accounts = accounts.order("created_at DESC").page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les derniers comptes utilisateurs crs" 
 form_tag admin_accounts_path, method: :get do 
 end 
 @accounts.each do |account| 
 link_to account.login, account.user 
 account.email 
 account.karma 
 account.current_sign_in_ip 
 account.inactive? ? "Inactif" : "Actif" 
 account.created_at.to_s(:posted) 
 if account.inactive? && account.user_id != 1 
 button_to "Activer",   [:admin, account], method: :put, class: "ok_button" 
 elsif !account.inactive? 
 button_to "Renvoi mot de passe", password_admin_account_path(account), class: "reset_password" 
 button_to "Suspendre", [:admin, account], method: :put, class: "delete_button" 
 end 
 if account.editor? 
 button_to "Retour simple visiteur", admin_account_editor_path(account.id), method: :delete 
 elsif account.moderator? 
 button_to "Retour simple visiteur", admin_account_moderator_path(account.id), method: :delete 
 elsif account.admin? 
 button_to "Retour simple visiteur", admin_account_admin_path(account.id), method: :delete 
 elsif !account.inactive? 
 button_to " modrateur", admin_account_moderator_path(account.id) 
 button_to " animateur", admin_account_editor_path(account.id) 
 button_to " admin", admin_account_admin_path(account.id) 
 end 
 end 
 paginate @accounts 

end

  end

  def password
    @account.send_reset_password_instructions
    redirect_to admin_accounts_url, notice: "Instructions pour changer le mot de passe envoyées"
  end

  def karma
    nb = params[:karma] || 50
    @account.give_karma nb
    @account.log_karma nb, current_account
    redirect_to @account.user
  end

  def update
    if @account.inactive?
      @account.reactivate!
      redirect_to :back, notice: "Compte réactivé"
    else
      @account.inactivate!
      redirect_to :back, notice: "Compte désactivé"
    end
  end

  def destroy
    @account.inactivate!
    redirect_to admin_accounts_url, notice: "Compte désactivé"
  end

protected

  def load_account
    @account = Account.find(params[:id])
    @account.amr_id = current_user.id
  end

end
