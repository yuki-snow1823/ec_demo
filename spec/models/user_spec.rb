# frozen_string_literal: true

require 'rails_helper'

describe "ユーザーモデルについて" do
  context "通常ユーザー" do
    it "エラーがなければ保存できる" do
      expect(build(:user)).to be_valid
    end
  end

  context "管理者ユーザー" do
    it "名前がなくても有効であること" do
      admin_user = build(:user, :admin)
      expect(admin_user).to be_valid
    end
  end
end

