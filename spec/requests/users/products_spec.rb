require 'rails_helper'

RSpec.describe "Users::Products", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/users/products/index"
      expect(response).to have_http_status(:success)
    end
  end
<<<<<<< HEAD
=======

>>>>>>> 4fe7621 (users/productsコントローラーの作成)
end
