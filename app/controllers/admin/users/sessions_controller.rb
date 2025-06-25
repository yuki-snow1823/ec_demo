# frozen_string_literal: true

class Admin::Users::SessionsController < Devise::SessionsController
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
    self.resource = warden.authenticate(auth_options)

    if resource.nil?
      flash[:alert] = "メールアドレスまたはパスワードが正しくありません"
      redirect_to new_user_session_path
      return
    end

    unless resource.admin?
      flash[:alert] = "認証できませんでした"
      sign_out resource
      redirect_to new_user_session_path
      return
    end

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    redirect_to admin_products_path
  end
end
