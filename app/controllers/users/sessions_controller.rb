# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def create
    form_params = params[:public_users_user]
    user = User.find_by(email: form_params[:email])

    if user&.admin?
      flash[:alert] = "認証できませんでした"
      redirect_to public_users_user_session_path
      return
    end

    if user == nil
      flash[:alert] = "メールアドレスまたはパスワードが正しくありません"
      redirect_to public_users_user_session_path
      return
    end

    unless user.valid_password?(form_params[:password])
      flash[:alert] = "メールアドレスまたはパスワードが正しくありません"
      redirect_to public_users_user_session_path
      return
    end

    self.resource = user
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    redirect_to users_products_path
  end
end
