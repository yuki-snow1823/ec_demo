# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  context "通常ユーザー" do
    it "ユーザー用のログイン画面からログインできる" do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "login"

      expect(page).to have_content "メールアドレスまたはパスワードが正しくありません"
    end

    
  end
  
end
