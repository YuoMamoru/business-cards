# frozen_string_literal: true

require "rails_helper"
require "json"

RSpec.describe "API", type: :request do
  describe "GET /api/postcode" do
    it "gets address when given a 7-digits code" do
      get poostcode_path(postcode: "100-0000")
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["address"]).to eq "東京都千代田区"
    end
  end

  describe "GET /api/postcode" do
    it "fails when given a code other than 7 digits" do
      get poostcode_path(postcode: "100")
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["address"]).to be_nil
    end
  end

  describe "GET /api/postcode" do
    it "fails when given no code" do
      get poostcode_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["address"]).to be_nil
    end
  end
end
