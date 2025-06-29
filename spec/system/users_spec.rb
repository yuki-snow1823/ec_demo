# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  context "通常ユーザー" do
    it "ユーザー用のログイン画面からログインできる" do
      visit new_public_users_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      expect(page).to have_current_path(users_products_path)
    end

    it "管理者用ログイン画面でログインできない" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("認証できませんでした")
    end
  end

  context "管理者ユーザー" do
    it "管理者用ログイン画面からログインできる" do
      visit new_user_session_path
      fill_in "Email", with: admin.email
      fill_in "Password", with: admin.password
      click_button "Log in"

      expect(page).to have_current_path(admin_products_path)
    end

    it "ユーザー用ログイン画面ではログインできない" do
      visit new_public_users_user_session_path
      fill_in "Email", with: admin.email
      fill_in "Password", with: admin.password
      click_button "Log in"

      expect(page).to have_content "認証できませんでした"
    end
  end
  
end
