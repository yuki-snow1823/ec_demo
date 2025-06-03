require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/products/index"
      expect(response).to have_http_status(:success)
    end
    pending "add some examples (or delete) #{__FILE__}"
  end
end
